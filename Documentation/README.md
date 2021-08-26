## Setting up a *MATLAB&reg; Network License Manager on Google Cloud Platform&trade; using Terraform&reg;*

### About Network License Manager:

Use of MathWorks&reg; products on cloud often requires a license manager within the network to checkout licenses securely.This repository will help in automating the process of launching a network license manager for MATLAB and other toolboxes, running on a Linux virtual machine, on Google Cloud Platform within a Google Cloud&trade; project. For information about the architecture of this solution, see [Learn About Network License Manager for MATLAB Architecture](#architecture-of-a-network-license-manager-setup-on-google-cloud). This repository uses [Terraform to provision Google Cloud resources](https://cloud.google.com/docs/terraform) with declarative configuration files.

This reference architecture helps in automating the process of **setting up MATLAB Network License Manager on Google Cloud Platform using a sample Terraform configuration.**

### About Terraform and Google Platform Provider:

[Terraform](https://www.terraform.io/intro/index.html) is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.

Terraform [Google Cloud Platform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) is used to configure your Google Cloud Platform infrastructure with Terraform config files. See the [provider reference](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference) for more details on authentication or otherwise configuring the provider. 

The Google provider is jointly maintained by:

* The [Terraform Team](https://cloud.google.com/docs/terraform) at Google
* The Terraform team at [HashiCorp](https://www.hashicorp.com/?_ga=2.206188627.1519458328.1628777034-999678800.1614365084)

For more details on Releases, Feature and Bug Requests, please visit this [page](https://registry.terraform.io/providers/hashicorp/google/latest/docs).

These documents are an introductory guide to using the **reference architecture**:

### Contents:

* [Installation](Installation.md)
* [Authentication](Authentication.md)
* [Getting Started Example](Example.md)
* [Upload license and start License Manager](ManagingLicenseManager.md)
* [Logging](Logging.md)
* [Network Overview](Network.md)
* [References](References.md)

[//]: #  (Copyright 2021 The MathWorks, Inc.)
