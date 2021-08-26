# Create subnet
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.tag}-licensemanager-subnetwork"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = var.network_id
}
# (c) 2021 MathWorks, Inc.
