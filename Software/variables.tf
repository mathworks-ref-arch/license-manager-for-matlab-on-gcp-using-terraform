variable "app_project" {
  type = string
  default = "projectid"
  description = "Enter ProjectID"
}
variable "username" {
  type = string
  default = "user"
  description = "local user who is authenticated to ssh and run startup scripts"
}

variable "gce_ssh_key_file_path" {
  type = string
  default = "/home/local-gce-user/.ssh/google_compute_engine.pub"
  description = "/home/local-gce-user/.ssh/google_compute_engine.pub"
}

variable "region" {
  type = string
  default = "us-west1"
  description = "Enter cloud regions"
}

variable "zone" {
  type = string
  default = "us-west1-c"
  description = "Add zone for cluster vms"
}

# https://cloud.google.com/compute/vm-instance-pricing
# https://cloud.google.com/compute/docs/machine-types#n2_machine_types
variable "machine_types" {
  type    = string
  default = "n2-standard-4"
  description = "Select instance type such as n2-standard-2 , n2-standard-4 , n2-standard-8"
}

# Boot Disk OS details
variable "bootDiskOS" {
  type = string
  default = "ubuntu24"
  description = "Supported OS include: rhel7, rhel8, ubuntu22, ubuntu24"
}

variable "imageProject" {
  type = map
  default = {
    rhel7 = "rhel-cloud"
    rhel8 = "rhel-cloud"
    ubuntu22 = "ubuntu-os-cloud"
    ubuntu24 = "ubuntu-os-cloud"
  }
  description = "Global image project"
}

variable "imageFamily" {
  type = map
  default = {
    rhel7 = "rhel-7"
    rhel8 = "rhel-8"
    ubuntu22 = "ubuntu-2204-lts"
    ubuntu24 = "ubuntu-2404-lts"
  }
  description = "Global image family"
}

# Set this to `true` if new vpc config needs to be created and `false` if en existing one will be used
variable "create_new_vpc" {
 type = bool
 default = true
}

# Set this to existing network name if `create_new_vpc` is set to `false`
variable "existing_vpc_network" {
 type = string
 default = ""
}

# Provide Network tags for existing network
variable "network_tags" {
  type = list
  default = ["mlm"]
}

# Set to True if new subnet needs to be created
variable "subnet_create" {
  type = bool
  description = "User Input stating whether new subnet needs to be created or an existing subnet needs to be used"
  default = true
}

# Existing Subnet Name as Input
variable "existing_subnet" {
  type = string
  description = "Existing Subnet name within above selected existing VPC"
  default = ""
}

# Client IPs
# change this to the range specific to your organization
variable "allowclientip" {
  type        = set(string)
  default     = ["0.0.0.0/0"]
  description = "Add IP Ranges that would connect/submit job. E.g. [\"11.22.33.44/32\",\"55.66.77.88/32\"]"

  validation {
    condition     = length(var.allowclientip) > 0
    error_message = "The allowclientip variable must not be empty. This field should be formatted as <ip_address>/<mask>. E.g. [\"11.22.33.44/32\",\"44.55.66.77/32\"]"
  }

  validation {
    condition     = alltrue([for cidr in var.allowclientip : can(cidrhost(cidr, 0))])
    error_message = "Every entry in allowclientip must be a valid CIDR range, including the mask. Replace any placeholder values with the real public IP addresses of your deployment and client machines. E.g. [\"11.22.33.44/32\",\"44.55.66.77/32\"]"
  }
}

## Product specific variables

# MATLAB and Toolbox Version support
variable "Version" {
  type = string
  default = "R2026b"
  description = "Example: 'R2025b' , 'R2026a', 'R2026b'"
}

# Host_ID registered as VM MAC or VM IP
variable "LicenseHostActivation" {
  type = string
  description = "Is the network license activated with VOL Serial (MAC) or with INTERNET (IP).This variable can take values either `HOSTID` or `INTERNET`"
  default = "HOSTID"
}

# LicenseManagerPort
variable "LicenseManagerPort"{
  type = number
  description = "LicenseManagerPort"
  default = 27000
}

variable "VendorDaemonPort"{
  type = number
  description = "VendorDaemonPort"
  default = 27010
}

variable "tag" {
  default="user-nlm-26a"
  description = "A prefix to make resource names unique"
}

# (c) 2021-2026 MathWorks, Inc.
