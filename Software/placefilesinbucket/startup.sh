#!/bin/bash
# This script is used by Terraform as a part of the standard startup script for a Google Compute Engine VM.
# The script takes care of most of the dependency resolution and network license manager installation apart from enabling the Googl logging agent.
# This script is triggered by `main.tf` within the module mlm.
# This script does not run locally on the user's system.
# This script is accessed from a Google cloud storage bucket by the VM

# The user still needs to upload license and start the flexlm service using local scripts.
# See documentation

## Receive Input Arguments

# Google Cloud Storage bucket containing all scripts from folder Software/placefilesinbucket
SCRIPT_BUCKET_NAME=$1

# MATLAB Release selected
VERSION=$2

# Bucket to receive updated license
LICENSE_BUCKET_NAME=$3

# Ports
LICENSE_MANAGER_PORT=$4
VENDOR_DAEMON_PORT=$5

# Configure path for MATLAB Root and License Manager Log File
MATLAB_ROOT="/usr/local/MATLAB"
MLM_LOG_FILE="\/var\/tmp\/LM_TMW.log"

## Install dependencies based on Linux distro using the script `getLinuxDistro.sh`

# The script is downloaded from GCS bucket using gsutil and the user is provided permissions to execute the script.
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/getLinuxDistro.sh . && \
sudo chmod 777 getLinuxDistro.sh && \

# The `getLinuxDistro.sh` script is invoked here to determine the OS and resolve dependencies using either 
# `configure_yum.sh` and `install-deps-with-yum` OR `install-deps-with-apt`
./getLinuxDistro.sh ${SCRIPT_BUCKET_NAME} && \
echo "Completed dependency installation stage" && \

## Get required scripts for installing logging agent and installing fluentd
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install_logging_agent.sh . && \
sudo chmod 777 install_logging_agent.sh && \
./install_logging_agent.sh && \
echo "Finished installing logging agent." && \

# Configure FLEXLM logs to flow into Google Cloud Logging Agent
# Service will be started later
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/mlm-fluentd-log.conf . && \
sudo sed -i 's/path <LOGFILE>/path '"$MLM_LOG_FILE"'/' mlm-fluentd-log.conf && \
sudo cp mlm-fluentd-log.conf /etc/google-fluentd/config.d/mlm-fluentd-log.conf && \

# Download required scripts for license monitoring license update
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/monitor_license_restart_mlm.sh /opt && \
sudo chmod 777 /opt/monitor_license_restart_mlm.sh && \
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/loopcron.sh /opt && \
sudo chmod 777 /opt/loopcron.sh && \

# Mount license GCS bucket containing dummy license file
# Name should be license.lic
LICENSE_LOCATION="/opt/update_license"
sudo mkdir $LICENSE_LOCATION && \
sudo chmod -R 777 $LICENSE_LOCATION && \
gcsfuse ${LICENSE_BUCKET_NAME} $LICENSE_LOCATION && \
echo "License bucket mounted" && \

## Installing MATLAB Network License Manager and then monitoring for License upload 

# Create MATLAB ROOT directory
sudo mkdir -p ${MATLAB_ROOT}/${VERSION} && \
sudo chmod -R 777 ${MATLAB_ROOT} && \
sudo chmod -R 777 ${MATLAB_ROOT}/${VERSION} && \

# Download and Extract License manager binary based on Version selected
wget "https://ssd.mathworks.com/supportfiles/downloads/${VERSION}/license_manager/${VERSION}/daemons/glnxa64/mathworks_network_license_manager_glnxa64.zip" && \
unzip mathworks_network_license_manager_glnxa64.zip -d ${MATLAB_ROOT}/${VERSION} && \
ls ${MATLAB_ROOT}/${VERSION} && \

# Get Flexlm HostID for configuring license file
echo $(${MATLAB_ROOT}/${VERSION}/etc/glnxa64/lmutil lmhostid) > lmhost.txt && \
awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \
HostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
echo ${HostID} && \

# FlexLM has a dependency on directory /usr/tmp. Create one if it does not exist. Not a MATLAB enforced constraint.
# This is a FlexLM requirement.
if [ -d "/usr/tmp" ]; then
 echo "Directory /usr/tmp exists."
else
  sudo mkdir /usr/tmp && sudo chmod -R 775 /usr/tmp
fi

# Monitor license file location to start/restart mlm
/opt/loopcron.sh $LICENSE_LOCATION/license.lic $MATLAB_ROOT $VERSION $LICENSE_MANAGER_PORT $VENDOR_DAEMON_PORT

# Cleaning up local scripts
rm -rf getLinuxDistro.sh && \
rm -rf install-deps-with-apt.sh && \
rm -rf install-deps-with-yum.sh && \
rm -rf mathworks_network_license_manager_glnxa64.zip && \
rm -rf install_logging_agent.sh && \
rm -rf mlm-fluentd-log.conf

# (c) 2021 MathWorks, Inc.
