## Input variables for mpsworkernode module
variable "projectID" {
  type = string
  default = ""
  description = "Enter ProjectID"
}
# gcloud user with access to the projecta nd credentials
variable "username" {
  type = string
  default = ""
  description = "local user who is authenticated to ssh and run startup scripts"
}

# gcloud ssh credentials
variable "gce_ssh_key_file_path" {
  type = string
  description = "/home/local-gce-user/.ssh/google_compute_engine.pub"
  default = ""
}

## VM resource specific variables

# tag for naming resources
variable "tag" {
  description = "A prefix to make resource names unique"
  default=""
}

# instance hardware
variable "machine_type" {
  default = ""
  description = "n2-standard-2 , n2-standard-4 , n2-standard-8"
}

# boot disk OS - global image project
variable "imageProject" {
  type = string
  description = "Global image project"
  default = "debian-cloud"
}

# boot disk OS - global image family
variable "imageFamily" {
  type = string
  description = "Global image family"
  default = "debian-10"
}

# vpc for mps instance
variable "network" {
  default = ""
  description = "VPC network name"
}

# firewall target network tags for vm
variable "network_tags" {
  default = ["mlm"]
  description = "Target Network tags"
}

# subnet for resources
variable "subnetwork" {
  default = ""
  description = "subnet name"
}


## Temporary storage buckets

# GCS bucket containing shell scripts for installation
variable "scriptBucketName" {
  type = string
  description = "Name for creating a temporary cloud storage bucket to carry the scripts"
  default=""
}

## Permanent storage buckets

# GCS bucket required to receive license files
variable "licenseBucketName" {
  type = string
  description = "Name for  cloud storage bucket to carry the updated license"
  default=""
}

## Product specific variables

# MATLAB LICENSE Version
variable "Version" {
  type = string
  default = "R2021a"
  description = "Example 'R2021a' , 'R2020b', 'R2020a' , 'R2019b' etc"
}

## License Information

# Host_ID registered as VM MAC or VM IP
variable "licenseHostActivation" {
  description = "Is the network license activated with VOL Serial (MAC) or with INTERNET (IP). This variable can take values either `HOSTID` or `INTERNET`"
  default = "HOSTID"
}

# LicenseManagerPort
variable "licenseManagerPort"{
  type = number
  description = "LicenseManagerPort"
  default = 27000
}

# Flexlm vendor daemon port
variable "vendorDaemonPort"{
  type = number
  description = "VendorDaemonPort"
  default = 1049
}

# (c) 2021 MathWorks, Inc.
