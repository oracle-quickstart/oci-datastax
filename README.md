# oci-datastax
These are Terraform modules that deploy [DataStax Enterprise (DSE)](https://www.datastax.com/products/datastax-enterprise) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  They are developed jointly by Oracle and DataStax.

## Resource Manager Deployment

This Quick Start uses [OCI Resource Manager](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) to make deployment easy, sign up for an [OCI account](https://cloud.oracle.com/en_US/tryit) if you don't have one, and just click the button below:

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://console.us-ashburn-1.oraclecloud.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-quickstart/oci-datastax/archive/button.zip)

After logging into the console you'll walk through the selection of variables for the deployment.

Note, if you use this template to create another repo you'll need to change the link for the button to point at your repo.

## Local Development

First off we'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

If you want to not use ORM and deploy with the terraform CLI you need to rename
`provider.tf.cli -> provider.tf`. This is because authentication works slightly
differently in ORM vs the CLI.

Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/oracle-quickstart/oci-datastax.git
    cd oci-datastax/terraform
    ls

![](./images/01%20-%20git%20clone.png)

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](./images/02%20-%20terraform%20init.png)

## Deploy
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

That gives:

![](./images/03%20-%20terraform%20plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  The apply should take about five minutes to run.  Once complete, you'll see something like this:

![](./images/04%20-%20terraform%20apply.png)

When the apply is complete, the infrastructure will be deployed, but cloud-init scripts will still be running.  Those will wrap up asynchronously.  OpsCenter and Lifecycle Manager (LCM) will probably be up five minutes after you run apply.  The cluster might take another ten minutes to build after that.  Now is a good time to get a coffee.

## Login to DataStax Lifecycle Manager (LCM)
When the `terraform apply` completed, it printed out the URLs for OpsCenter and LCM.  Let's check out LCM first.  Open a browser to the URL from the output.  

![](./images/05%20-%20warning.png)

The username is `admin` and the password is whatever you specified in [variables.tf](simple/variables.tf).

![](./images/06%20-%20login.png)

In this case, the job isn't done yet.  If we drill down on clusters we can see that the nodes have been added but LCM hasn't yet SSH'd into them to install DSE.

![](./images/07%20-%20cluster.png)

Similarly, if we check out the job, we see it hasn't run yet.

![](./images/08%20-%20job.png)

Checking back a few minutes later, we see the job is complete!

![](./images/09%20-%20job%20done.png)

## Login to DataStax OpsCenter
Now that the LCM job is all done, let's take a look at OpsCenter.  Open up a browser to that URL.  It was printed as output when `terraform apply` completed.

![](./images/10%20-%20opscenter.png)

If everything ran ok, you should see a ring with the number of nodes you specified in [variables.tf](simple/variables.tf).

## View the Cluster in the Console
You can also login to the web console [here](https://console.us-phoenix-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running the cluster.

![](./images/11%20-%20console.png)

## SSH to a Node
These machines are using Ubuntu 16.  The default login is ubuntu.  You can SSH into the machine with a command like this:

    ssh -i ~/.ssh/oci ubuntu@<Public IP Address>

You can debug deployments by investigating the cloud-init log file `/var/log/cloud-init-output.log`.

If you want to get started interacting with the database you can run `cqlsh` with the default user `cassandra` and whatever password you specified in [variables.tf](simple/variables.tf).  For instance:

    cqlsh -u cassandra -p admin

This gives:

![](./images/12%20-%20cqlsh.png)

## Destroy the Deployment
When you no longer need the DSE cluster, you can run this to delete the deployment:

    terraform destroy

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](./images/13%20-%20terraform%20destroy.png)
