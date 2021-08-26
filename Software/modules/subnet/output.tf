# Name of the subnet created for license manager
output "name" {
  description = "SubNetwork name"
  value = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
}
# (c) 2021 MathWorks, Inc.
