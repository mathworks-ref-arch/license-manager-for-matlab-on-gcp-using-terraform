#!/bin/bash
# This script detects the OS of the VM and then selects appropriate scripts to install the dependencies for installing Network License manager on this VM
# The script switches between yum and apt based on the OS detected
# Supported OS include: (See MathWorks platform support for more details.)
# * rhel
# * centos
# * ubuntu
#
# This is a helper script called by startup script for the Google compute instance. This script does not run locally on the user's system.
# This script is accessed from a Google cloud storage bucket by the VM

SCRIPT_BUCKET_NAME=$1

## Get Linux Distribution
IFS=''
getmyos=$(grep '^ID=' /etc/os-release)
echo $getmyos

# Supported distributions and return values for `getmyos`
#ID="centos" ID=ubuntu ID="rhel"

## Extracting value after ID=
# Configure Delimiter
IFS='='
# One of the either read call will return empty while the other will have a non empty return string
read -a arr <<< "${getmyos}" || read -a arr <<< ${getmyos}

## Install MATLAB NETWORK LICENSE MANAGER  dependencies and gcsfuse
# Depending on OS flavour the script switches between apt and yum to fulfill dependencies

if [ ${arr[1]} = '"centos"' ]; then
  echo "FlexLM will be installed on OS: " ${arr[1]}
  sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install-deps-with-yum.sh . && \
  sudo chmod 777 install-deps-with-yum.sh && \
  sudo ./install-deps-with-yum.sh ${SCRIPT_BUCKET_NAME}
elif [ ${arr[1]} = '"rhel"' ]; then
  echo "FlexLM will be installed on OS: " ${arr[1]}
  sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install-deps-with-yum.sh . && \
  sudo chmod 777 install-deps-with-yum.sh && \
  sudo ./install-deps-with-yum.sh ${SCRIPT_BUCKET_NAME}
elif [ ${arr[1]} = "ubuntu" ]; then
  echo "FlexLM will be installed on OS: " ${arr[1]}
  sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/install-deps-with-apt.sh . && \
  sudo chmod 777 install-deps-with-apt.sh && \
  sudo ./install-deps-with-apt.sh
else
  echo "Unsupported OS"
fi

# (c) 2021 MathWorks, Inc.
