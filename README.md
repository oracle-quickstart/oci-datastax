# Important - This doesn't work yet!

# oci-terraform-dse
[simple](simple) is a Terraform module that will deploy DSE on OCI.  Instructions on how to use it are below.  Best practices are detailed in [this document](bestpractices.md).

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/cloud-partners/oci-datastax.git
    cd oci-datastax/simple
    ls

![](./images/1%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/2%20-%20terraform%20init.png)

## Deploy
Update `\<ssh_private_key_path\>` field in `remote-exec.tf` with the absolute path of your SSH private key. For example, `/Users/gilbertlau/.ssh/bmc_rsa`

You can test the deployment by running:

    terraform plan

If everything looks good, you can run it for real with the command:

    terraform apply

Assuming everything works, you'll see something like this:

![](./images/terraform_apply.png)

The time taken to deploy the default DSE cluster configuration is roughly 20 minutes long. Once complete, you can point your web browser to `https://<OpsCenter_URL>` and log into OpsCenter using `admin` as Username and the value of OpsCenter_Admin_Password as the Password. The OpsCenter instance uses a self-signed SSL certificate, so you will need to accept the certificate exception before you can see the OpsCenter's login page.

![](./images/opsc_login.png)

![](./img/opsc_dashboard.png)

You can SSH into the any of the DSE nodes using this command:

    ssh -i <path to your SSH private key> opc@<IP address of a DSE node>

The IP address of your DSE node in OCI Console is under Compute >> Instances >> Instance Details.

![](./images/dse_ip.png)

You can cqlsh into your DSE nodes using

    cqlsh <IP address of a DSE node> \
      -u cassandra \
      -p <Cassandra_DB_User_Password>

## Destroy the Deployment
When you no longer need the DSE cluster, you can run this to delete the deployment:

    terraform destroy
