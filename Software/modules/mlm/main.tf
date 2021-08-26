# Creates  a compute instance for setting up License Manager and assigns network, disk and address to it

# Static public - ip for  MLM node
resource "google_compute_address" "mlmnode-static-ip-address" {
  name = "${var.tag}-static-ip-address"
}

# Creating instance for MATLAB Production Server
#   Instance Type              - machine_type
#   Firewall rules applicable  - tags
#   Boot Disk image            - image
#   Boot Disk Size             - size
#   Access & Permissions       - scopes
#   Startup script             - metadata_startup_script
#   VPC and Subnet             - network_interface

resource "google_compute_instance" "mlm_node" {
  name = "${var.tag}-mlm-node"
  machine_type = var.machine_type
  tags = var.network_tags
  allow_stopping_for_update = true

boot_disk {
    initialize_params {
      image = "${var.imageProject}/${var.imageFamily}"
      size = 50
    }
  }

metadata = {
    ssh-keys = "${var.username}:${file(var.gce_ssh_key_file_path)}"
}

service_account {
  scopes = ["compute-rw", "storage-full", "cloud-platform", "logging-write", "monitoring-write", "userinfo-email" , "service-management", "service-control"]
}

# Setting start up script with input arguments

metadata_startup_script = "gsutil cp gs://${var.scriptBucketName}/startup.sh . && sudo chmod 777 startup.sh && ./startup.sh ${var.scriptBucketName} ${var.Version} ${var.licenseBucketName} ${var.licenseManagerPort} ${var.vendorDaemonPort}"

# Providing network input

network_interface {
  subnetwork = var.subnetwork
  access_config {
     nat_ip = google_compute_address.mlmnode-static-ip-address.address
  }
}

lifecycle {

  }
}

# (c) 2021 MathWorks, Inc.
