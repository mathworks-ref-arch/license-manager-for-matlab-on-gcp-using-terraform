#!/bin/bash

# This script checks if license is available at Software/license on the local machine
# License file name expected is license.lic

# Input arguments
PWD=$(pwd)
LICENSE_FILE=$1
DIR_PATH=${PWD}/license

# Check for directory
if [ -d $DIR_PATH ]; then
  
  FILE_PATH=${PWD}/license/${LICENSE_FILE}

  # Verify if license has been placed within Software/license
  if [ ! -f "$FILE_PATH" ]; then
    echo "Cannot find ${LICENSE_FILE} at ${PWD}/license."
    printf "\n Place a valid license file e.g. license.lic at ${PWD}/license"
    exit 1
  else
    echo "Found ${LICENSE_FILE} at ${PWD}/license for license manager set up"
    exit 0
  fi
else
  echo "Cannot find directory 'Software/license'. Make sure you have this directory and a valid license file within it."
  exit 1
fi

# (c) 2021 MathWorks, Inc.
