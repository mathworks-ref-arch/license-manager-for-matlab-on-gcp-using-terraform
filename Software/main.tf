# Provider and credentials
provider "google" {
  credentials = file("credentials.json")
  project = var.app_project
  region = var.region
  zone = var.zone
}

# Create a GCS bucket for uploading license file post license manager installation
resource "google_storage_bucket" "license" {
  name = "${var.tag}-license-bucket"
  force_destroy = true
  provisioner "local-exec" {
   command = "./local_scripts/check_for_licensefile.sh license.lic && gsutil -m cp ./license/license.lic gs://${google_storage_bucket.license.name}"
 }
}

# Create a GCS bucket to host installation scripts for the duration of deployment only
resource "google_storage_bucket" "script" {
  depends_on = [ google_storage_bucket.license ]   
  name = "${var.tag}-build-tempscript-bucket"
  force_destroy = true
  provisioner "local-exec" {
   command = "gsutil -m cp -r ./placefilesinbucket/* gs://${google_storage_bucket.script.name}/"
 }
}

# Create vpc
module "mlm_vpc_network" {
  depends_on = [ google_storage_bucket.license ]   
  count = var.create_new_vpc ? 1:0
  source  = "./modules/vpc_network"
  tag     = var.tag
  project = var.app_project
  allowclientip  = var.allowclientip
  licenseManagerPort = var.LicenseManagerPort
  vendorDaemonPort = var.VendorDaemonPort
  network_tags = var.network_tags
}

# Use existing VPC
data "google_compute_network" "input_vpc_network" {
  count = var.create_new_vpc ? 0 : 1
  name = var.existing_vpc_network
}

# Add firewall rules to allow mlm connections for existing network
resource "google_compute_firewall" "allow-mlm" {
  depends_on = [ google_storage_bucket.license ]
  count = var.create_new_vpc ? 0 : 1
  name = "${var.tag}-fw-allow-http"
  network = var.existing_vpc_network
  allow {
    protocol = "tcp"
    ports    = [var.LicenseManagerPort,var.VendorDaemonPort,"22"]
  }
  target_tags = var.network_tags
  source_ranges = [var.allowclientip]
}

# Create subnet
module "mlm_subnet" {
  depends_on = [ google_storage_bucket.license ]
  count = var.subnet_create ? 1:0
  source  = "./modules/subnet"
  tag          = var.tag
  ip_cidr_range = "10.128.0.0/20"
  region        = var.region
  network_id    = var.create_new_vpc ? module.mlm_vpc_network[0].id : data.google_compute_network.input_vpc_network[0].id
}

# Use existing subnet
data "google_compute_subnetwork" "input-subnetwork" {
  count = var.subnet_create ? 0 : 1
  name = var.existing_subnet
  region = var.region
}

# Creating VM for MATLAB Network License Manager
module "mlm_node" {

  depends_on = [ google_storage_bucket.script, module.mlm_vpc_network, module.mlm_subnet , google_storage_bucket.license ]

  source  = "./modules/mlm"
  # access
  projectID = var.app_project
  username = var.username
  gce_ssh_key_file_path = var.gce_ssh_key_file_path

  # resources
  tag = var.tag

  # Network resources
  network = var.create_new_vpc ? module.mlm_vpc_network[0].name : data.google_compute_network.input_vpc_network[0].name
  subnetwork = var.subnet_create ? module.mlm_subnet[0].name : data.google_compute_subnetwork.input-subnetwork[0].name
  network_tags = var.network_tags

  # Compute instance type
  machine_type = var.machine_types

  # storage
  scriptBucketName = google_storage_bucket.script.name
  licenseBucketName = google_storage_bucket.license.name

  # product versioning
  Version = var.Version

  # Base OS - Linux dist and version
  imageProject = var.imageProject[var.bootDiskOS]
  imageFamily  = var.imageFamily[var.bootDiskOS]

  # license
  licenseManagerPort = var.LicenseManagerPort
  vendorDaemonPort = var.VendorDaemonPort
  licenseHostActivation = var.LicenseHostActivation
}

# GetFlexLMhostid
resource "null_resource" "getflexlmhostid"{
  depends_on = [ module.mlm_node ]
  provisioner "local-exec" {
    command = "./local_scripts/checkinstall.sh ${var.Version} ${module.mlm_node.name} ${var.zone}"
  }
}

# Delete Storage bucket to avoid costs
resource "null_resource" "removescriptbucket"{
  depends_on = [ module.mlm_node , null_resource.getflexlmhostid ]
  provisioner "local-exec" {
    command = "gsutil rm -r gs://${google_storage_bucket.script.name}"
  }
}

#(c) 2021 MathWorks, Inc.
