# Inputs for Subnet Module

# Tag for uniquely naming resources
variable "tag" {
  description = "A prefix to make resource names unique"
  default=""
}

# IP CIDR range for Subnet
variable "ip_cidr_range" {
  description = "Subnet CIDR range"
  default=""
}

# Cloud region for network resources
variable "region" {
  description = "GCP network region"
  default=""
}

# Network ID for which subnet will be created
variable "network_id" {
  description = "Network ID of the vpc network for production server"
  default=""
}
# (c) 2021 MathWorks, Inc.
