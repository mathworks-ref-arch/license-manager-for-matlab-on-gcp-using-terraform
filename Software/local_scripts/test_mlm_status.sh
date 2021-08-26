#!/bin/bash

# This script is used to access license manager status

# Input arguments
VERSION=$1
MLM_HOST=$2
ZONE=$3
MATLAB_ROOT="/usr/local/MATLAB/${VERSION}"
printf "\n\n\n"
echo -e "\e[1mChecking if License Manager is up and running.\e[0m"
flag=0
timeout_counter=0
timeout_limit=9

# Check for MLM install status till either of the condition is met
# - flag = 1 : Either status returned says "License Manager is UP"
# - timeout : timeout_counter>9 i.e. more than 9 minutes have elapsed
while [ $flag -ne 1 ] && [ $timeout_counter -le $timeout_limit ]
do
    
    # Test mlm instance health
    status=$(gcloud compute ssh ${MLM_HOST} --zone ${ZONE} --command "${MATLAB_ROOT}/etc/glnxa64/lmutil lmstat -a -c ${MATLAB_ROOT}/etc/license.dat" 2>/dev/null)
    success_sub_str='license server UP (MASTER)'

    if [[ $status = "" ]]; then
        # License Manager is not installed yet
        echo "Still setting up license manager."
        sleep 1m
        # Keep checking for status update
    else
        if [[ "$status" == *"$success_sub_str"* ]]; then
           # License manager is installed and status is UP
            echo -e "\e[1mLicense manager is UP.\e[0m"
            printf "\n\n"
            echo -e "\e[1m$status\e[0m"
            # Exit if flag is 1
            flag=1
        else
           # License manager is installed but status is not UP
            echo -e "\e[1mLicense manager status reported.\e[0m"
            printf "\n\n"
            echo -e "\e[1m$status\e[0m"
            # Keep checking for status update
            sleep 30
        fi
    fi
    # Increment time out counter
    timeout_counter=$((timeout_counter+1))
done

if ! [ $timeout_counter -le $timeout_limit ]; then
    printf "\n"
    echo "Health check for deployment has timed out. Check Google Cloud Logs for the Compute instance ${MLM_HOST} to find more."
    printf "\n"
fi


# (c) 2021 MathWorks, Inc.
