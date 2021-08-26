# vpc for MLM
resource "google_compute_network" "vpc_network" {
  name = "${var.tag}-licensemanager-network"
  auto_create_subnetworks = false
  project = var.project
}
# (c) 2021 MathWorks, Inc.
