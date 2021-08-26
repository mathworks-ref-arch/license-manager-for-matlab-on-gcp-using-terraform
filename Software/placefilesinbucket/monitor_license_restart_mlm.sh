#!/bin/bash
# 
# This script is called by loopcron.sh as a background process to continuously monitor /opt/update_license/license.lic file for changes
# The Google cloud Storage bucket for license upload is mounted at "/opt/update_license" folder and contains a template/dummy license.lic file
# When a license.lic file is uploaded to the bucket, `gcsfuse mount` allows the file to change within /opt/update_license
# This script detects the change in file metadata and triggers license manager startup
#

LICENSE_FILE=$1
MATLAB_ROOT=$2
VERSION=$3
LM_PORT=$4
DAEMON_PORT=$5

# Name of the license file for server to read from
LICENSE_DAT_FILE="license.dat"

# Get Flexlm HostID for configuring license file
echo $(${MATLAB_ROOT}/${VERSION}/etc/glnxa64/lmutil lmhostid) > lmhost.txt && \
awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \

HostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
echo ${HostID} && \

## Support for IP based Flex LM (Optional)
#  ---------------------------------------
#
# Use the below line as the SERVER line if license is activated using IP instead of MAC
#     echo "SERVER $(hostname) INTERNET=${INTERNET}  ${LM_PORT}" >> license.dat
#######################################################################################


# Apply License file monitoring cron job
while true; do
        current=$(sudo find ${LICENSE_FILE} -type f -ctime -1 -exec ls -ls {} \;)
        sleep 15
        new=$(sudo find ${LICENSE_FILE} -type f -ctime -1 -exec ls -ls {} \;)
        if [[ "$current" != "$new" ]];then
                # Stop any running MLM service
                ${MATLAB_ROOT}/${VERSION}/etc/glnxa64/lmutil lmdown

                # Check for existing license.dat file and remove if one is present
                if [[ -f $LICENSE_DAT_FILE ]]; then
                   rm -rf ${LICENSE_DAT_FILE}
                fi

                # Create license.dat file using license.lic and lmhostid details
                # ADD SERVER and DAEMON lines to configure the license file
                echo "SERVER $(hostname) ${HostID}  ${LM_PORT}" >> $LICENSE_DAT_FILE && \
                echo "DAEMON MLM " "/usr/local/MATLAB/${VERSION}/etc/MLM" " port=${DAEMON_PORT}" >> $LICENSE_DAT_FILE && \
                cat ${LICENSE_FILE} >> ${LICENSE_DAT_FILE} && \
                
                # Make a copy of license.dat at matlabroot/version/etc
                # Check for existing license.dat file and remove if one is present
                if [[ -f ${MATLAB_ROOT}/${VERSION}/etc/license.dat ]]; then
                        rm -rf ${MATLAB_ROOT}/${VERSION}/etc/license.dat
                fi
                cp ${LICENSE_DAT_FILE} ${MATLAB_ROOT}/${VERSION}/etc/license.dat && \
                                        
                # Start license server using the new license file
                echo "Trying to Start License Manager" && \
                ${MATLAB_ROOT}/${VERSION}/etc/glnxa64/lmgrd -c ${MATLAB_ROOT}/${VERSION}/etc/license.dat && \
                ${MATLAB_ROOT}/${VERSION}/etc/glnxa64/lmutil lmstat -a

                # Restart Logging agent to pipe logs from LM_TMW.log
                sudo service google-fluentd restart
         fi
done

# (c) 2021 MathWorks, Inc.
