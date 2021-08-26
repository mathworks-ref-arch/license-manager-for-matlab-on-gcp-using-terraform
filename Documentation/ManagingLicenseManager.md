# Setting up License Manager

Once the license manager has been installed on the Google Cloud Instance using the reference architecture, the server needs to be provided with a valid and active MATLAB license. To do so a license administrator will need to activate the license with the `flexlmhostid` of the `google cloud compute instance` used for network license manager deployment. A sample output for the Terraform template can look like the following snippet:
```
Outputs:

compute_zone = "us-central1-a"
license_bucket = "mlm-21a-ubuntu20-1629991370-license-bucket"
mlm_host_id = "10.128.0.2"
mlm_host_name = "mlm-21a-ubuntu20-1629991370-mlm-node"
mlm_host_port = 27000
subnet_name = "mlm-21a-ubuntu20-1629991370-licensemanager-subnetwork"
version = "R2021a"
vpc_network_name = "mlm-21a-ubuntu20-1629991370-licensemanager-network"


Extracting output values from Terraform:
---------------------------------------
License Manager is being setup on mlm-21a-ubuntu20-1629991370-mlm-node with IP 10.128.0.2 running at port 27000
License Manager Version R2021a
Network Details include network_name = mlm-21a-ubuntu20-1629991370-licensemanager-network subnet = mlm-21a-ubuntu20-1629991370-licensemanager-subnetwork zone = us-central1-c


Querying FlexLM HostID for License Manager host:
-----------------------------------------------

Visit MathWorks license center to activate license using the HOSTID of the instance.

Use HOSTID as 42010a800002 to activate license.

Created file lmhost.txt containing HOSTID for future reference.

Rename the MATLAB license file to be hosted as license.lic. This activated license.lic file can be uploaded to the Google Cloud Storage Bucket: mlm-21a-

ubuntu20-1629991370-license-bucket .This will automatically trigger MATLAB network license manager service to start provided the license is valid and activated.


You can remotely check server status using the following command.
./local_scripts/test_mlm_status.sh R2021a mlm-21a-ubuntu20-1629991370-mlm-node us-central1-c

Deployment complete.

```

Steps for **activating license using flexlmhostid** can be found [here](https://www.mathworks.com/matlabcentral/answers/97719-how-do-i-use-the-license-center).

## Uploading license file to Google Cloud Storage Bucket:

The above section describes how a user can access the `hostid` and activate the license on [MathWorks License Center](https://www.mathworks.com/licensecenter).
The next step is to upload the license file to the `Terraform` resource, `google-storage-bucket.license`. 

You can upload the license file in 2 ways:
* **Upload using the Google Cloud Storage interface on the web :**
  A user can visit https://console.cloud.google.com/storage/browser and access the `Google Cloud Storage bucket` created by the reference arcitecture. The interface allows one to interactively click on upload file and select the license.lic file available with the license administrator.
* **Upload using the command line utility `gsutil`:**
  ```
  gsutil cp -m Software/license/license.lic gs://bucketnameforlicenseupload
  ```

## Managing Network License Manager

The FlexLM setup provides a number of commands that allow a user to access status and manage a network license manager installation.

This repository provides helper scripts that allow the user to perform all the operations remotely using `gcloud` command line utility. You will need a set of ssh credentials to authenticate the gcloud commands communicating with the license manager instance.

These scripts are located within `Software/local_scripts`.

**Examples of using the helper scripts:**

Querying License Manager status:
```
Version="R2021a"
mlmHostName="gcp-${Version}-ubuntu"
zone="us-central1-c"

./Software/local_scripts/test_mlm_status.sh ${Version} ${mlmHostName} ${zone}
```

Get FlexLMHostID of the Google Compute engine instance:
```
Version="R2021a"
mlmHostName="gcp-${Version}-ubuntu"
zone="us-central1-c"

./Software/local_scripts/get_flexlm_hostid.sh ${Version[1]} ${mlmHostName[1]} ${zone}
```

Starting the License Manager on Host:
```
Version="R2021a"
mlmHostName="gcp-${Version}-ubuntu"
zone="us-central1-c"

./Software/local_scripts/start_mlm.sh ${Version[1]} ${mlmHostName[1]} ${zone}
```

[//]: #  (Copyright 2021 The MathWorks, Inc.)
