# Host ip for license manager instance created
output "mlm_node_private_ip" {
value = google_compute_instance.mlm_node.network_interface.0.network_ip
}

# Hostname for license manager instance
output "name" {
   value = google_compute_instance.mlm_node.name
}

# VPC network name assigned   
output "VPC_network_name" {
  value = var.network
}

# Subnet name assigned
output "subnet_name" {
  value = var.subnetwork
}
# (c) 2021 MathWorks, Inc.
