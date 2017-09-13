# oracle-bmc-terraform-dse [Multiple BMC regions mapping to DSE Datacenters]
Oracle Bare Metal Cloud Services Terraform-based provisioning for DataStax Enterprise (DSE)

This asset creates a virtual cloud network with a route table, Internet Gateway, Security Lists, 3 subnets on different availability domains (ADs) for the DataStax Enterprise cluster nodes using NVMe SSDs as data disks and DataStax Enterprise OpsCenter in BMC Phoenix region.  Additionally, it creates the same assets in BMC Ashburn region instead of creating a DataStax Enterprise OpsCenter but connecting to the DataStax Enterprise OpsCenter instance in BMC Phoenix region.

### Disclaimer
The use of this repo is intended for development purpose only.  Usage of this repo is solely at user’s own risks.  There is no SLAs around any issues posted on this repo.  Internal prioritization of repo issues will be processed by the owners of this repo periodically.  There is no association with any technical support subscription from DataStax.

The use of DataStax software is free in development. Deploying and running DataStax software on a cloud provider will incur costs associated with the underlying cloud provider’s resources such as compute, network and storage, etc.  Please refer to your cloud provider for effective cloud resources pricing.

### Prerequisites
* [Follow this link to install Terraform and Oracle BMC Terraform provider (v1.0.14)](https://github.com/oracle/terraform-provider-baremetal/blob/master/README.md)
* [Follow this link to set up your Oracle BMC's fingerprint for Oracle BMC APIs access](https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm)
* [Follow this link to set up SSH key pair for your Oracle BMC BM or VM instances](https://docs.us-phoenix-1.oraclecloud.com/Content/GSG/Tasks/creatingkeys.htm)

&nbsp;&nbsp;&nbsp;After following these links you should have completed these tasks:
* Installed the `terraform` binary for your OS.
* Installed the `terraform-provider-baremetal` release ([version v1.0.14](https://github.com/oracle/terraform-provider-baremetal/releases/tag/v1.0.14)) and created the ~/.terraformrc file that specifies the path to the baremetal provider.
* Created an Oracle BMC API Signing Key Pair under ~/.oraclebmc directory.
* Uploaded the public key from the above pair to Oracle BMC to generate the key's fingerprint.
* Created an SSH key pair to be used instead of a password to authenticate a remote user under your ~/.ssh directory.

### Using this project
* Run `% git clone https://github.com/DSPN/oracle-bmc-terraform-dse.git` to clone the Oracle BMC DSPN repo.
* Run `% cd oracle-bmc-terraform-dse/multi-region` to change to the repo directory.
* Update env-vars file with the required information.
  * From your Oracle BMC account
    * TF_VAR_tenancy_ocid
    * TF_VAR_user_ocid
    * TF_VAR_fingerprint
    * TF_VAR_private_key_path
    * TF_VAR_region
  * From your local file system
    * TF_VAR_ssh_public_key
    * TF_VAR_ssh_private_key

* Source env-vars for appropriate environment
  * `% . env-vars`
* Update `variables.tf` with your instance options if you need to change the default settings.  In particular, you need to proivde your DataStax Academy credentials in order to execute the terraform templates. If you do not have a DataStax Academy account yet, you can register [here](https://academy.datastax.com/user/register?destination=home).
```
# DataStax Academy Credentials for DSE software download
variable "DataStax_Academy_Creds" {
  type = "map"

  default = {
    username = "<Your DataStax Academy username>"
    password = "<Your DataStax Academy password>"
  }
}
```
The default configuration will provision a DSE cluster with 3 nodes in Phoenix region and 3 nodes in Ashburn region with one node in each availability domain (AD) defined below.  For instance, AD1_Count inside DSE_Cluster_Topology_PHX_Region map variable represents node count in availability domain 1 of Phoenix region namely, FcAL:PHX-AD-1. Each BMC region is mapped to a DSE datacenter construct.
```
# DSE cluster deployment topology by availability domain (Phoenix region: PHX)
variable "DSE_Cluster_Topology_PHX_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "1"
    AD3_Count = "1"
  }
}

# DSE cluster deployment topology by availability domain (Ashburn region: IAD)
variable "DSE_Cluster_Topology_IAD_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "1"
    AD3_Count = "1"
  }
}
```
You can modify the node count in each availability domain to satisfy your deployment requirements.
* Update \<ssh_private_key_path\> field in `remote-exec.tf` with the absolute path of your SSH private key. For example, `/Users/gilbertlau/.ssh/bmc_rsa`
* Run `% terraform plan` and follow on-screen instructions to create and review your execution plan.
* If everything looks good, run `% terraform apply` and follow on-screen instructions to provision your DSE cluster. *Currently the install will automatically create nodes in 3 Availability Domains (AD). The number you would like in each AD is specified by the Num_DSE_Nodes_In_Each_AD variable inside the variables.tf file*.
* If it runs successfully, you will see the following output from the command line.
![](./multi-region/img/terraform_apply.png)
* The time taken to deploy the default DSE cluster configuraiton is roughly 20 minutes long. Once complete, you can point your browser at http://<OpsCenter_URL> to access DataStax Enterprise OpsCenter to start managing your DSE cluster.
![](./img/opsc_dashboard.png)
* You can also SSH into the any of the DSE nodes using this command: `% ssh -i <path to your SSH private key> opc@<IP address of a DSE node>`.  You can locate the IP address of your DSE node in Oracle BMC Console's Compute>>Instances>>Instance Details screen.
![](./img/dse_ip.png)
* Similarly, you can cqlsh into your DSE nodes using `% cqlsh <IP address of a DSE node> -u cassandra -p <Cassandra_DB_User_Password>`.
* When you no longer need the DSE cluster, you can run `% terraform destroy` and follow on-screen instructions to de-provision your DSE cluster.

### Files in the configuration

#### `env-vars`
This is used to export the environmental variables for the configuration. These are usually authentication related, be sure to exclude this file from your version control system. It's typical to keep this file outside of the configuration.

Before you run "terraform plan", "terraform apply", or "terraform destroy", source the configuration file as follows:  
`$ . env-vars`

#### `compute.tf`
Defines the compute resource

#### `network.tf`
Defines the network resource

#### `remote-exec.tf`
Uses a `null_resource`, `remote-exec` and `depends_on` to execute a command on the instance. [More information on the remote-exec provisioner.](https://www.terraform.io/docs/provisioners/remote-exec.html) 

#### `./userdata/*`
The user-data scripts that get injected into an instance on launch. More information on user-data scripts can be [found at the cloud-init project.](https://cloudinit.readthedocs.io/en/latest/topics/format.html)

#### `variables.tf`
Defines the variables used in the configuration

#### `datasources.tf`
Defines the datasources used in the configuration

#### `outputs.tf`
Defines the outputs of the configuration

#### `provider.tf`
Specifies and passes authentication details to the OBMCS TF provider
