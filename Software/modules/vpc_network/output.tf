# Resource ID for VPC created
output "id" {
  description = "Network ID for the VNET"
  value = google_compute_network.vpc_network.id
}

# Name for VPC created
output "name" {
  description = "Network name for the VNET"
  value = google_compute_network.vpc_network.name
}

# Firewall ID
output "firewall" {
  description = "Firewall rules associated "
  value = google_compute_firewall.allow-license-checkout.id
}
# (c) 2021 MathWorks, Inc.
