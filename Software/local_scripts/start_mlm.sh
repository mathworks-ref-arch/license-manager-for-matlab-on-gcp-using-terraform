#!/bin/bash

# This script is sued to remotely start license manager using gcloud utility
#Input arguments
VERSION=$1
MLM_HOST=$2
ZONE=$3
APP_PROJECT=$4
MATLAB_ROOT="/usr/local/MATLAB/${VERSION}"

# Test mlm instance health
gcloud compute ssh ${MLM_HOST} --zone ${ZONE} --project ${APP_PROJECT} --command "${MATLAB_ROOT}/etc/glnxa64/lmgrd -c ${MATLAB_ROOT}/etc/license.dat -l /var/log/LM_TMW.log"

# (c) 2021 MathWorks, Inc.
