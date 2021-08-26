#!/bin/bash

# Install dependencies
SCRIPT_BUCKET_NAME=$1

# Install libxst family, unzip, curl and wget
sudo yum install -y unzip redhat-lsb libx* wget curl && \

# Configuring yum repo for gcsfuse and installing gcsfuse
sudo gsutil cp gs://${SCRIPT_BUCKET_NAME}/configure_yum.sh . && \
sudo chmod 777 configure_yum.sh && \
sudo ./configure_yum.sh && \
sudo yum -y install gcsfuse

# (c) 2021 MathWorks, Inc.
