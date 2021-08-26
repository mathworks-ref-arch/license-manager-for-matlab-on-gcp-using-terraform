## Sample example for using Reference Architecture

The [example script](../Software/exampleSetUpNetworkLicenseManager.sh) is a sample scenario for deploying a MATLAB Network License Manager on Google Cloud Platform.

The example has the following pre-requisites:
* User has access to an existing Google Cloud service account and valid ssh keys.
* User has access to a valid MathWorks product license.
* User has Google Cloud IAM roles configured to provide access to the following scopes:
    * compute-rw
    * storage-full
    * cloud-platform
    * logging-write
    * monitoring-write
    * userinfo-email
    * service-management
    * service-control
* MATLAB Release for License Manager. Supported versions include R2020a, R2020b and R2021a.

Once the user has access to all the above `prerequisites` they can proceed to the following steps:
* Configure default values for  [`Software/variables.tf`](../Software/variables.tf).
* Customize and run the [example](../Software/exampleSetUpNetworkLicenseManager.sh).


The sample scenario in this example is as follows:

* OS: `Ubuntu20`
* Compute: `n2-standard-4`
* Number of instances required: `1`
* Use existing VPC & Subnet: `false`
* MATLAB Version: `R2021a`


### Variables overriden within the example:

```
## Recommended practice is to use the latest version of License manager.
# This supports previous version license checkout as well.
Version="R2021a"

# VM Operating system
BootDiskOS="ubuntu20"

## Set up a MATLAB Network License Manager on Google Cloud
Create_VPC=true
Create_Subnet=true

## The existing networks will be used only if above 2 inputs are set to false
Existing_VPC_network="tf-test-network"
Existing_Subnet="test-tf-subnet"

# Configure variable `machine_types` with instance type
Instance="n2-standard-4"

# Unique tag for naming resources
TS=$(date +%s) && \
BUILD_TAG="mlm-${Version:(-3)}-${BootDiskOS}-${TS}"
```

The above variables are just a subset of a much longer list that needs to be configured within `Software/variables.tf`. The above values will override the defaults set within variables.tf .

The next section applies the terraform plan. If you encounter an error related to `unrecognized modules or plan`, initialize the Terraform modules by running the following command:
```
>> cd Software
>> terraform init
>> terraform validate
```

### Applying Terraform plan:

At the completion of the deployment a `MATLAB network license manager` installation will be available on a `Google Cloud Compute Instance`. Additionally a `Google Cloud Storage bucket` will be available for the user the upload the `license.lic` file to trigger the License Manager to start and allow license checkouts.

The Terraform output should provide the following:
* `VPC and subnet` details for the License Manager VM.
* Private IPs and `hostname` for the Network License manager VM.
* The `FLEXLM HOSTID` of the Network License manager VM required to activate a valid MathWorks product license at the license center. See more details for this steps [at](ManagingLicenseManager.md)
* Name of the `Google Cloud Storage bucket` assigned to receive updated and active  `license.lic` file.


```
# Apply Terraform configuration for setting up a Network License manager

terraform apply -auto-approve -var "create_new_vpc=${Create_VPC}" \
-var "subnet_create=${Create_Subnet}" \
-var "existing_vpc_network=${Existing_VPC_network}" \
-var "existing_subnet=${Existing_Subnet}" \
-var "bootDiskOS=${BootDiskOS}" \
-var "Version=${Version}" \
-var "machine_types"=${Instance} \
-var "tag=${BUILD_TAG}"
```

### Verify deployment status is successful and extract Terraform output:

Proceed only if terraform apply has ended with exit code 0. 

```
exit_status=$?
```

If the deployment is successful the script extracts the `terraform output` values. The script uses `jq` to parse terraform output in `json` format as follows.

```
if [[ $exit_status -eq 0 ]]; then

## Extract Terraform Output values
mlmHostID=$(terraform output -json | jq '.mlm_host_id.value' | tr -d \") && \
mlmHostName=$(terraform output -json | jq '.mlm_host_name.value' | tr -d \") && \
mlmPort=$(terraform output -json | jq '.mlm_host_port.value' | tr -d \") && \
Version=$(terraform output -json | jq '.version.value' | tr -d \") && \
vpc_network=$(terraform output -json | jq '.vpc_network_name.value' | tr -d \") && \
subnet=$(terraform output -json | jq '.subnet_name.value' | tr -d \") && \
zone=$(terraform output -json | jq '.compute_zone.value' | tr -d \") && \
license_bucket=$(terraform output -json | jq '.license_bucket.value' | tr -d \")

fi
```

The script also queries the `FlexLM HostID`

```
resultstr=$(./local_scripts/get_flexlm_hostid.sh ${Version} ${mlmHostName} ${zone} 2>/dev/null)
flex=$? && \
if [[ $flex -eq 0 ]]; then
    echo $resultstr > lmhost.txt && \
    awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \
    flexHostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
    echo ${flexHostID}
fi
```

Here is an example of the Terraform output received at the completion of the deployment:

```
Outputs:

compute_zone = "us-central1-c"
license_bucket = "mlm-21a-ubuntu20-1629991370-license-bucket"
mlm_host_id = "10.128.0.2"
mlm_host_name = "mlm-21a-ubuntu20-1629991370-mlm-node"
mlm_host_port = 27000
subnet_name = "mlm-21a-ubuntu20-1629991370-licensemanager-subnetwork"
version = "R2021a"
vpc_network_name = "mlm-21a-ubuntu20-1629991370-licensemanager-network"

Extracting output values from Terraform
License Manager is being setup on mlm-21a-ubuntu20-1629991370-mlm-node with IP 10.128.0.2 running at port 27000
License Manager Version R2021a
Network Details include network_name = mlm-21a-ubuntu20-1629991370-licensemanager-network subnet = mlm-21a-ubuntu20-1629991370-licensemanager-subnetwork zone = us-central1-c

Querying FlexLM HostID for License Manager host.
42010a800002

Visit MathWorks license center to activate license using the HOSTID of the instance.
Use HOSTID as 42010a800002 to activate license.
Created file lmhost.txt containing HOSTID for future reference.
Rename the MATLAB license file to be hosted as license.lic. This activated license.lic file can be uploaded to the Google Cloud Storage Bucket: mlm-21a-ubuntu20-1629991370-license-bucket .This will automatically trigger license manager service to start provided the license is valid and activated.


You can remotely check server status using the following command.
./local_scripts/test_mlm_status.sh R2021a mlm-21a-ubuntu20-1629991370-mlm-node us-central1-c

Deployment complete.

```



[//]: #  (Copyright 2021 The MathWorks, Inc.)
