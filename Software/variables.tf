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
  default = "us-central1"
  description = "Enter cloud regions"
}

variable "zone" {
  type = string
  default = "us-central1-c"
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
  default = "ubuntu20"
  description = "Supported OS include: rhel7, rhel8, ubuntu16, ubuntu18, ubuntu20"
}

variable "imageProject" {
  type = map
  default = {
    rhel7 = "rhel-cloud"
    rhel8 = "rhel-cloud"
    ubuntu16 = "ubuntu-os-cloud"
    ubuntu18 = "ubuntu-os-cloud"
    ubuntu20 = "ubuntu-os-cloud"
  }
  description = "Global image project"
}

variable "imageFamily" {
  type = map
  default = {
    rhel7 = "rhel-7"
    rhel8 = "rhel-8"
    ubuntu16 = "ubuntu-1604-lts"
    ubuntu18 = "ubuntu-1804-lts"
    ubuntu20 = "ubuntu-2004-lts"
  }
  description = "Global image family"
}

# Set this to `true` if new vpc config needs to be created and `false` if en existing one will be used
variable "create_new_vpc" {
 type = bool
 default = false
}

# Set this to existing network name if `create_new_vpc` is set to `false`
variable "existing_vpc_network" {
 type = string
 default = "tf-test-network"
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
  default = false
}

# Existing Subnet Name as Input
variable "existing_subnet" {
  type = string
  description = "Existing Subnet name within above selected existing VPC"
  default = "test-tf-subnet"
}

# Client IPs
# change this to the range specific to your organization
variable "allowclientip" {
  default = "0.0.0.0/0"
  type = string
  description = "Add IP Ranges that would connect/submit job e.g. 0.0.0.0/0"
}

## Product specific variables

# MATLAB and Toolbox Version support
variable "Version" {
  type = string
  default = "R2021a"
  description = "Example: 'R2020a' , 'R2020b', 'R2021a'"
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
  default = 1049
}

variable "tag" {
  default="username-mlm-21a"
  description = "A prefix to make resource names unique"
}

# (c) 2021 MathWorks, Inc.
