## Network Overview

A Virtual Private Cloud (VPC) network inside Google Cloud Platform provides the following:

* Provides connectivity for Compute Engine virtual machine (VM) instances, including Google Kubernetes Engine (GKE) clusters, App Engine flexible environment instances, and other Google Cloud products built on Compute Engine VMs.
* Offers native Internal TCP/UDP Load Balancing and proxy systems for Internal HTTP(S) Load Balancing.
* Connects to on-premises networks using Cloud VPN tunnels and Cloud Interconnect attachments.
* Distributes traffic from Google Cloud external load balancers to backends.

Google Cloud projects can contain multiple VPC networks. Unless you create an organizational policy that prohibits it, new projects start with a default network (an auto mode VPC network) that has one subnetwork (subnet) in each region.

### VPC implementation in this reference architecture:

The VPC network can be configured by the user through the module [`vpc_network`](../Software/modules/vpc_network/main.tf). This module creates a VPC for the MATLAB License Manager VM taking into account the folowing inputs:
1. Google Cloud Project
2. Firewall related inputs:
   * TCP Ports for Ingress
   * Source IP range for Ingress
   * Target tags

The VPC network inherits the zone and region of the Google Cloud project selected by the user.

The TCP ports for ingress is labelled as `mlm` and the default value used for MATLAB Network License Manager is `27000` and for Vendor daemon port is `1049`. The user has the flexibility to provide a different port values through `variables.tf`.

### Network and Subnet

Based on [Google Cloud documentation](https://cloud.google.com/vpc/docs/vpc), each VPC network consists of one or more subnets. Each subnet is associated with a region. VPC networks do not have any IP address ranges associated with them. IP ranges are defined for the subnets.

A network must have at least one subnet before it can be sued. Auto mode VPC networks create subnets in each region automatically. Custom mode VPC networks start with no subnets, giving you full control over subnet creation. You can create more than one subnet per region. For information about the differences between auto mode and custom mode VPC networks, [see types of VPC networks](https://cloud.google.com/vpc/docs/vpc#subnet-ranges).

The Google Cloud VPC network created in this reference architecture is a custom mode VPC. The configuration `auto_create_subnetworks` has been set to `false` to avoid auto creation of default subnets for every region.

See network definition below:

```
resource "google_compute_network" "vpc_network" {
  name = "${var.tag}-licensemanager-network"
  auto_create_subnetworks = false
  project = var.project
}
```

The process of creating an Google Compute instance involves selecting a zone, a network, and a subnet. The subnets available for selection are restricted to those in the selected region. Google Cloud assigns the instance an IP address from the range of available addresses within the subnet

The subnet is a regional resource and requires a user to provide a value for the cloud `region` it will be created and the VPC `network` it should be associated with. 

Subnet primary and secondary IP address ranges must be a [valid CIDR block](https://cloud.google.com/vpc/docs/vpc#valid-ranges).

For more information, see [working with subnets](https://cloud.google.com/vpc/docs/using-vpc#subnet-rules).

This is an example of a subnet definition in Terraform:

```
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.tag}-licensemanager-subnetwork"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = var.network_id
}
```

### Routes and Firwall rules:

**Routes** define paths for packets leaving instances (egress traffic). Each VPC network has an associated [dynamic routing mode](https://cloud.google.com/vpc/docs/vpc#routing_for_hybrid_networks) that controls the behavior of all of its Cloud Routers. Cloud Routers share routes to your VPC network and learn custom dynamic routes from connected networks.

* **Regional dynamic routing** is the default. In this mode, routes to on-premises resources learned by a given Cloud Router in the VPC network only apply to the subnets in the same region as the Cloud Router.

* **Global dynamic routing** changes the behavior of all Cloud Routers in the network such that the routes to on-premises resources that they learn are available in all subnets in the VPC network, regardless of region.

**Note:** 
By `default` the network created using this reference archiecture will have `Regional` dynamic routing. If one needs the network to have `Global` dynamic routing, the configuration will have to be `customized` using the Terraform Google provider resource `google_compute_network` and the following optional argument:

`routing_mode` - (Optional) The network-wide routing mode to use. If set to `REGIONAL`, this network's cloud routers will only advertise routes with `subnetworks of this network in the same region` as the router. If set to `GLOBAL`, this network's cloud routers will advertise routes with `all subnetworks of this network, across regions`. Possible values are REGIONAL and GLOBAL.

Read more about this configuration [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network).

### Configuring Network License Manager for other MathWorks products deployed on cloud:

Ideally for secure network based license checkout, the best practice is to have the **network license manager instance hosting the licenses in the same VPC network as other MathWorks products deployed on Google cloud**, such as `MATLAB`, `MATLAB Production Server`, `MATLAB Parallel Server` and `MATLAB Web App Server`. In this scenario it is secure to have all the compute resources `share the same VPC` and hence one needs to take care of the following:

* If for example the compute instance for License Manager is planned for a `region different` from that of MATLAB Production Server instance then the VPC should be confgured to be `GLOBAL`.
* If the network policy is to use an existing VPC and the VPC is `REGIONAL` by configuration, then the reference architecture configuration for both `license manager` and `MATLAB Production Server` should be provided with the `same region` as an input.

**Firewall Rules**

Firewall rules apply to both outgoing (egress) and incoming (ingress) traffic in the VPC network. Firewall rules control traffic even if it is entirely within the network, including communication among VM instances.

Every VPC network has [implied firewall rules](https://cloud.google.com/vpc/docs/firewalls#default_firewall_rules); two implied IPv4 firewall rules, and if IPv6 is enabled, two implied IPv6 firewall rules. The implied egress rules allow most egress traffic, and the implied ingress rules deny all ingress traffic. You cannot delete the implied rules, but you can [override them with your own rules](https://cloud.google.com/vpc/docs/using-firewalls). Google Cloud always blocks some traffic, regardless of firewall rules; for more information, see [blocked traffic](https://cloud.google.com/vpc/docs/firewalls#blockedtraffic).

Firewall configuration used within this reference architecture is defined within `network-firewall.tf` also defined within the module `vpc_network`.

The current configuration assumes a single rule for allowing INGRESS for all MATLAB Network License Manager client traffic as follows:
```
resource "google_compute_firewall" "allow-http-ssh" {
  name = "${var.tag}-fw-allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22",var.licenseManagerPort, var.vendorDaemonPort]
  }
  target_tags = var.network_tags
  source_ranges = [var.allowclientip]
}
```

[//]: #  (Copyright 2021 The MathWorks, Inc.)
