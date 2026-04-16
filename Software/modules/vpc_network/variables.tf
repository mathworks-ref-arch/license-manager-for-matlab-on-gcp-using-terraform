# GCP project name
variable "project" {
  description = "ProjectID"
  default = ""
}

# Tag to uniquely name resources
variable "tag" {
  description = "A prefix to make resource names unique"
  default=""
}

# License Manager port
variable "licenseManagerPort" {
  description = "Access License Manager at this port"
  default=27000
}

# FLEX LM Daemon port
variable "vendorDaemonPort" {
  description = "FLEXLM Vendor daemon at this port"
  default=27010
}

# Provide target tags for instances to apply firewall rules
variable "network_tags" {
  type = list
  default = ["mlm"]
}

# Client IPs
# change this to the range specific to your organization
variable "allowclientip" {
  type        = set(string)
  default     = []
  description = "Add IP Ranges that would connect/submit job"
}
# Copyright 2021-2026 The MathWorks, Inc.
