# allow traffic with the following firewall rule
resource "google_compute_firewall" "allow-license-checkout" {
  name = "${var.tag}-fw-allow-license-checkout"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22",var.licenseManagerPort, var.vendorDaemonPort]
  }
  target_tags = var.network_tags
  source_ranges = toset(var.allowclientip)
}

# Copyright 2021-2026 The MathWorks, Inc.
