#!/bin/bash
#
# This script is called by the startup.sh
# This script simply calls the monitoring script as a ackground process and exits the shell

LICENSE_FILE=$1
MATLAB_ROOT=$2
VERSION=$3
LM_PORT=$4
DAEMON_PORT=$5

/opt/monitor_license_restart_mlm.sh $LICENSE_FILE $MATLAB_ROOT $VERSION $LM_PORT $DAEMON_PORT &
exit 0

# (c) 2021 MathWorks, Inc.
