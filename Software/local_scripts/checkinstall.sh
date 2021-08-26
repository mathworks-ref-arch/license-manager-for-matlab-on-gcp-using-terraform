#!/bin/bash
#
# This script is used to check if license manager installation is complete and flexlmhostid is available.
# This utilizes the helper script get_flexlm_hostid.sh within Software/local_scripts to query until the query is successful or the request times out.

# Input arguments
Version=$1
zone=$3
host=$2
timeout_flag=0
inc=30

echo Version: $Version
echo hostname: $host
echo zone: $zone

# Call helper function get_flexlm_hostid to query flexlm hostid for license activation
resultstr=$(./local_scripts/get_flexlm_hostid.sh ${Version} ${host} ${zone} 2>/dev/null)
flex=$? && \
if [[ $flex -eq 0 ]]; then
	echo $resultstr > lmhost.txt && \
	awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \
	HostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
	echo ${HostID} && \
	rm -rf lmhost.txt
else
	while [ $flex -ne 0 ] 
	do
		sleep 10 && \
		echo "Installation of License Manager version ${Version} is in progress." && \
		printf "\n" && \
		timeout_flag=$[timeout_flag+10] && \
		if [ $timeout_flag -gt 1000 ]; then
			echo "Installation check has timed out. Please check logs" && \
			break
		else
			resultstr=$(./local_scripts/get_flexlm_hostid.sh ${Version} ${host} ${zone} 2>/dev/null)
			flex=$? && \
			if [[ $flex -eq 0 ]]; then
				echo $resultstr > lmhost.txt && \
				awk 'BEGIN {FS="\""}{echo $2}' lmhost.txt && \
				HostID=$(awk 'BEGIN {FS="\""};{print $2}' lmhost.txt) && \
				echo ${HostID} && \
				rm -rf lmhost.txt
			fi
		fi
	done
fi