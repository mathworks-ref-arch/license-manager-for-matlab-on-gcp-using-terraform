## Authentication

In order to make requests against any required Google Cloud Platform API, the user needs to authenticate himself/herself. The preferred method of provisioning resources with Terraform is to use a Google Cloud [service account](https://cloud.google.com/iam/docs/service-accounts), that can be granted a limited set of IAM permissions scoped out by the platform administrator.

In order to access a set of credentials, a user can visit the [service account key page in the Cloud Console](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts?supportedpurview=project) and choose an accessible Google cloud project to list the existing service accounts. One can either choose an existing service account, or create a new one based on permissions. [See steps for creating a service account](https://cloud.google.com/docs/authentication/production#create_service_account). Once a service account is ready for use, the user needs to download the JSON key file from the selected service account on the local machine/VM being used for provisioning. The next step is to define an environment variable `GOOGLE_APPLICATION_CREDENTIALS` to provide application level access to the credentials. [See instructions for setting the environment variable](https://cloud.google.com/docs/authentication/production#passing_variable). 

Also, provide the location of the credentials within `variables.tf` in both Build and Deploy stage as shown below.

```
# Path to service account credentials 
variable "credentials_file_path"{
  type = string
  default = "credentials.json"
  description = "Provide full path to the credentials file for your service account"
}
```
[For more details, see Terraform documentation on support for adding credentials](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials).

Terraform configuration uses some startup scripts for initialization of VMs. To authenticate Terraform requires `metadata-based SSH key configurations`. **Create a set of SSH keys** if one does not exist. See this [link](https://cloud.google.com/compute/docs/instances/adding-removing-ssh-keys#createsshkeys) for steps. Provide the location of this key within `variables.tf` for both Build and Deploy stage as shown below:

```
# Path to ssh key for gcloud login and authorization
variable "gce_ssh_key_file_path" {
  type = string
  description = "/home/local-gce-user/.ssh/google_compute_engine.pub"
  default = "/home/matlabuser/.ssh/google_compute_engine.pub"
}
```

[//]: #  (Copyright 2021 The MathWorks, Inc.)