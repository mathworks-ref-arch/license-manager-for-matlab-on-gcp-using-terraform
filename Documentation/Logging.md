## Logging for Google Compute Engine using Logging Agent

Google Cloud's operations suite provides the following agents for collecting logs from VM instances. There are 2 types of logging agents:
* **Ops Agent**: the primary agent for collecting telemetry from your Compute Engine instances. This agent combines logging and metrics into a single agent, providing YAML-based configurations for collecting your logs and metrics, and features high-throughput logging.
* **Legacy Logging agent**: streams logs from common third-party applications and system software to Logging. You can configure the agent to stream additional logs.

See details on [Ops Agent](https://cloud.google.com/logging/docs/agent/ops-agent) and [Legacy Logging Agent](https://cloud.google.com/logging/docs/agent/logging).

This `reference architecture` uses the `Cloud Logging agent`, an application based on [fluentd](https://www.fluentd.org/) that runs on the Google Cloud virtual machine (VM) instances. It is a best practice to run the Logging agent on all your VM instances. See [supported OS](https://cloud.google.com/logging/docs/agent/logging/managing-agent-policies#supported_operating_systems) for the logging agent.

### Installing the Logging Agent:

To install the Logging agent, the reference architecture uses a helper script [install_logging_agent.sh](../Software/placefilesinbucket/install_logging_agent.sh) which mostly comprises of the following commands. 


```
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh

sudo bash add-logging-agent-repo.sh --also-install

```

To see the detailed steps, visit [Installing the Cloud Logging agent on a VM](https://cloud.google.com/logging/docs/agent/logging/installation#joint-install).

### Configuring the Logging Agent:

The Logging agent `google-fluentd` is a modified version of the [fluentd](https://www.fluentd.org/) log data collector. The Logging agent comes with a [default configuration](https://cloud.google.com/logging/docs/agent/default-logs); in most common cases, no additional configuration is required.

MATLAB Network License Manager logs require minimal configuration for the logging agent to stream the logs to [Cloud Logging Dashboard](https://cloud.google.com/logging/docs/view/dashboard).

The cloud agent config is defined within [mlm-fluentd-log.conf](../Software/placefilesinbucket/mlm-fluentd-log.conf).

Basic `parameters` that have been configured is shown in the below table:

|Configuration name|	Type|	Default|	Description|
|------|------|-----|----|
|format|	`@type none`	|The format of the logs. This is unstructured text incase of MATLAB Network License Manager logs.|
|path|	string|	`/var/tmp/LM_TMW.log`|The path is the path to license manager logs.|
|pos_file|	string|	`/var/lib/google-fluentd/pos/mlm-fluentd-log.pos` |	The path of the position file for this log input. fluentd records the position it last read into this file. Review the detailed [fluentd documentation](https://docs.fluentd.org/input/tail#pos_file-highly-recommended).|
|read_from_head|	bool|	`true`|	Whether to start to read the logs from the head of file instead of the bottom. Review the detailed fluentd documentation.|
|tag|	string|	`mlm-logs`|	The log tag for this log input.|

See [Google Cloud documentation](https://cloud.google.com/logging/docs/agent/logging/configuration) for more details.


[//]: #  (Copyright 2021 The MathWorks, Inc.)
