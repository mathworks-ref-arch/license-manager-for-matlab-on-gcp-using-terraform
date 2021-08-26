#!/bin/bash

# Install dependencies using apt

sudo apt-get update && \

# Remove requirement on cursor addressable terminal.
sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo apt-get install -y -q
sudo apt-get install -y lsb-core && \

#Install wget, curl and  unzip package
sudo apt-get --assume-yes install wget unzip curl && \

# Install gcsfuse for mounting GCS buckets
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
sudo echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list && \
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
sudo apt-get update
sudo apt-get -y install gcsfuse

# (c) 2021 MathWorks, Inc.
