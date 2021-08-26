#!/bin/bash
# This script downloads and installs Google's logging agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

# (c) 2021 MathWorks, Inc.