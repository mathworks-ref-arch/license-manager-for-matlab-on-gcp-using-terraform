#!/bin/bash

# This script is sued to remotely start license manager using gcloud utility
#Input arguments
VERSION=$1
MLM_HOST=$2
ZONE=$3
MATLAB_ROOT="/usr/local/MATLAB/${VERSION}"

# Test mlm instance health
gcloud compute ssh ${MLM_HOST} --zone ${ZONE} --command "${MATLAB_ROOT}/etc/glnxa64/lmgrd -c ${MATLAB_ROOT}/etc/license.dat -l /var/tmp/LM_TMW.log"

# (c) 2021 MathWorks, Inc.
