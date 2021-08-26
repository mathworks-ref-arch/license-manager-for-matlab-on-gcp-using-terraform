#!/bin/bash

# This is an example script for setting up MATLAB Network License Manager on Google cloud platform.

    # Sample Requirements:
        # OS: Ubuntu20
        # Compute: n2-standard-4 machine
        # Number of nodes : 1
        # Existing GCP VPC & Subnet : True/False
        # Version : R2021a

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

# Initialize and Validate Terraform scripts
echo Initializing Terraform ...
terraform init && \

echo Validating Terraform scripts before applying plan for License Manager...
terraform validate && \

## Create GCP resources for setting up a Network License manager
terraform apply -auto-approve -var "create_new_vpc=${Create_VPC}" \
-var "subnet_create=${Create_Subnet}" \
-var "existing_vpc_network=${Existing_VPC_network}" \
-var "existing_subnet=${Existing_Subnet}" \
-var "bootDiskOS=${BootDiskOS}" \
-var "Version=${Version}" \
-var "machine_types"=${Instance} \
-var "tag=${BUILD_TAG}"

exit_status=$?

if [[ $exit_status -eq 0 ]]; then

## Extract Terraform Output values
mlmHostID=$(terraform output -json | jq '.mlm_host_id.value' | tr -d \") && \
mlmHostName=$(terraform output -json | jq '.mlm_host_name.value' | tr -d \") && \
mlmPort=$(terraform output -json | jq '.mlm_host_port.value' | tr -d \") && \
Version=$(terraform output -json | jq '.version.value' | tr -d \") && \
vpc_network=$(terraform output -json | jq '.vpc_network_name.value' | tr -d \") && \
subnet=$(terraform output -json | jq '.subnet_name.value' | tr -d \") && \
zone=$(terraform output -json | jq '.compute_zone.value' | tr -d \") && \
license_bucket=$(terraform output -json | jq '.license_bucket.value' | tr -d \") && \

printf "\n\n\nExtracting output values from Terraform\n" && \
echo -e "License Manager is being setup on \e[1m${mlmHostName}\e[0m with IP \e[1m${mlmHostID}\e[0m running at port \e[1m${mlmPort}\e[0m" && \
echo -e "License Manager Version \e[1m${Version}\e[0m" && \
echo -e "Network Details include network_name = \e[1m${vpc_network}\e[0m subnet = \e[1m${subnet}\e[0m zone = \e[1m${zone}\e[0m"

printf "\n\n\n" &&\
echo -e "\e[1mQuerying FlexLM HostID for License Manager host.\e[0m" && \

resultstr=$(./local_scripts/get_flexlm_hostid.sh ${Version} ${mlmHostName} ${zone} 2>/dev/null)
flex=$? && \
if [[ $flex -eq 0 ]]; then
    echo $resultstr > lmhost.txt && \
    awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \
    flexHostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
    echo ${flexHostID}
fi

printf "\nVisit MathWorks license center to activate license using the HOSTID of the instance.\n" && \
echo -e "Use HOSTID as \e[1m${flexHostID}\e[0m to activate license." && \
echo -e "Created file \e[1mlmhost.txt\e[0m containing HOSTID for future reference."
echo -e "Rename the MATLAB license file to be hosted as \e[1mlicense.lic\e[0m. This \e[1mactivated license.lic file can be uploaded to the Google Cloud Storage Bucket: ${license_bucket}\e[0m .This will automatically trigger license manager service to start provided the license is valid and activated."

printf "\n\n"
echo -e "You can remotely check server status using the following command."
echo -e "./local_scripts/test_mlm_status.sh ${Version} ${mlmHostName} ${zone}"
echo -e "Deployment complete."
fi

# (c) 2021 MathWorks, Inc.