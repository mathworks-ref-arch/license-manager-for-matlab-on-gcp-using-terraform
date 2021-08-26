# Host id for License Manager
output "mlm_host_id" {
 value = module.mlm_node.mlm_node_private_ip
}

# Host name for License Manager
output "mlm_host_name" {
  value = module.mlm_node.name
}

# License Manager port access
output "mlm_host_port" {
  value = var.LicenseManagerPort
}

# MATLAB version
output "version" {
  value = var.Version
}

# GCP network in use
output "vpc_network_name" {
  value = var.create_new_vpc ? module.mlm_vpc_network[0].name : data.google_compute_network.input_vpc_network[0].name
}

# GCP subnet in use
output "subnet_name" {
  value = var.subnet_create ? module.mlm_subnet[0].name : data.google_compute_subnetwork.input-subnetwork[0].name
}

# GCP instance zone
output "compute_zone" {
  value = var.zone
}

# Upload activated license to the License Bucket
output "license_bucket" {
  value = google_storage_bucket.license.name
}

# (c) 2021 MathWorks, Inc.
