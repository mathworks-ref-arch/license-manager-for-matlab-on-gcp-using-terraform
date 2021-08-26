## Installation

### Cloning this repository

Clone this repository as follows:
```
>> git clone https://github.com/mathworks-ref-arch/network-license-manager-on-gcp-using-terraform.git
```

### Installing Google Cloud SDK:

Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install). This step will ensure you are able to run `gcloud` and `gsutil` commands from the system provisioning Google Cloud resources. Perform gcloud authentication using command `gcloud auth login`. This will authorize the gcloud API to access the Cloud Platform with your Google user credentials.

### Installing Terraform:

[Install Terraform](https://www.terraform.io/upgrade-guides/1-0.html) v1.0 for Linux.

### Create SSH keys for managing Google Compute resources:

Terraform configuration uses some startup scripts for initialization of VMs. To authenticate Terraform requires `metadata-based SSH key configurations`. **Create a set of SSH keys** if one does not exist. See this [link](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#createsshkeys) for steps. Provide the location of this key within `variables.tf` for both Build and Deploy stage as follows.
```
# Path to ssh key for gcloud login and authorization
variable "gce_ssh_key_file_path" {
  type = string
  description = "/home/local-gce-user/.ssh/google_compute_engine.pub"
  default = "/home/matlabuser/.ssh/google_compute_engine.pub"
}
```

### Selecting MATLAB versions for License Manager:

Select MATLAB releases you would like to support. A version of MATLAB Network License Manager supports license checkout for previous versions of MATLAB and toolboxes as well. MATLAB Network License Manager binaries are available at this [link](https://www.mathworks.com/support/install/license_manager_files.html) for reference.

Provide the latest version you would like to install within [variables.tf](../Software/variables.tf) as follows:

```
variable "Version" {
  type = string
  default = "R2021a"
  description = "Example: 'R2020a' , 'R2020b', 'R2021a'"
}
```
Keep a template `license.lic` file within `Software\license`. This is a necessary placeholder for a monitoring script on the server. You can leave the file contents blank as well. The monitoring script will expect a license upload/update post deployment to trigger the license manager startup.


[//]: #  (Copyright 2021 The MathWorks, Inc.)
