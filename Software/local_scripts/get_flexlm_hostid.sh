#!/bin/bash

# Inputs for querying hostid using gcloud utility
VERSION=$1
MLM_HOST=$2
ZONE=$3
MATLAB_ROOT="/usr/local/MATLAB/${VERSION}"

# Test mlm instance health
gcloud compute ssh ${MLM_HOST} --zone ${ZONE} --command "${MATLAB_ROOT}/etc/glnxa64/lmutil lmhostid"

# (c) 2021 MathWorks, Inc.
