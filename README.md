# oco-terraform-dse
This Terraform module deploys a DataStax Enterprise (DSE) cluster to Oracle Cloud Infrastructure (OCI).

## Install Terraform and the OCI Provider
First off, we need to install Terraform.  Instructions on that are [here](https://www.terraform.io/intro/getting-started/install.html).  You can test that Terraform is properly installed by running `terraform`:

![](./img/1%20-%20terraform.png)

Next you're going to need to install the [Terraform Provider for Oracle Cloud Infrastructure](https://github.com/oracle/terraform-provider-baremetal/blob/master/README.md).  I'm on a Mac, so I downloaded a copy of the binary, `darwin_amd64.tar.gz` from [here](https://github.com/oracle/terraform-provider-oci/releases) and put it in a new plugins directory:

![](./img/2%20-%20provider.png)

* [Set up your OCI's fingerprint for OCI APIs access](https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm)
* [Set up SSH key pair for your OCI BM or VM instances](https://docs.us-phoenix-1.oraclecloud.com/Content/GSG/Tasks/creatingkeys.htm)
* Created an OCI API Signing Key Pair under ~/.oraclebmc directory.
* Uploaded the public key from the above pair to OCI to generate the key's fingerprint.
* Created an SSH key pair to be used instead of a password to authenticate a remote user under your ~/.ssh directory.

Now you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/benofben/oci-terraform-dse.git
    cd oci-terraform-dse
    ls

![](./img/3%20-%20git%20clone.png)

## Deploy
Update env-vars file with the required information:

From your OCI account
* TF_VAR_tenancy_ocid
* TF_VAR_user_ocid
* TF_VAR_fingerprint
* TF_VAR_private_key_path

From your local file system
* TF_VAR_ssh_public_key
* TF_VAR_ssh_private_key

Source env-vars for appropriate environment
`% . env-vars`

Update `variables.tf` with your instance options if you need to change the default settings.  In particular, you need to proivde your DataStax Academy credentials in order to execute the terraform templates. If you do not have a DataStax Academy account yet, you can register [here](https://academy.datastax.com/user/register?destination=home).

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

The default configuration will provision a DSE cluster with 3 nodes in Phoenix region and 3 nodes in Ashburn region with one node in each availability domain (AD) defined below.  For instance, AD1_Count inside DSE_Cluster_Topology_PHX_Region map variable represents node count in availability domain 1 of Phoenix region namely, FcAL:PHX-AD-1. Each OCI region is mapped to a DSE datacenter construct.

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
Finally, you can replace our provided custom passwords for Cassandra DB user "cassandra" and OpsCenter "admin" user with your own passwords.

```
variable "Cassandra_DB_User_Password" {
  default = "datastax1!"
}

variable "OpsCenter_Admin_Password" {
  default = "opscenter1!"
}
```

Update \<ssh_private_key_path\> field in `remote-exec.tf` with the absolute path of your SSH private key. For example, `/Users/gilbertlau/.ssh/bmc_rsa`

Run `% terraform plan` and follow on-screen instructions to create and review your execution plan.

If everything looks good, run `% terraform apply` and follow on-screen instructions to provision your DSE cluster.

If it runs successfully, you will see the following output from the command line.
![](./img/terraform_apply.png)

The time taken to deploy the default DSE cluster configuraiton is roughly 20 minutes long. Once complete, you can point your web browser to https://<OpsCenter_URL> and log into OpsCenter using "admin" as Username and the value of OpsCenter_Admin_Password as the Password. *The OpsCenter instance uses a self-signed SSL certificate, so you will need to accept the certificate exception before you can see the OpsCenter's login page.*
![](./img/opsc_login.png)
![](./img/opsc_dashboard.png)

You can also SSH into the any of the DSE nodes using this command: `% ssh -i <path to your SSH private key> opc@<IP address of a DSE node>`.  You can locate the IP address of your DSE node in OCI Console's Compute>>Instances>>Instance Details screen.

![](./img/dse_ip.png)

Similarly, you can cqlsh into your DSE nodes using `% cqlsh <IP address of a DSE node> -u cassandra -p <Cassandra_DB_User_Password>`.

## Destroy the Deployment
When you no longer need the DSE cluster, you can run `% terraform destroy` and follow on-screen instructions to de-provision your DSE cluster.
