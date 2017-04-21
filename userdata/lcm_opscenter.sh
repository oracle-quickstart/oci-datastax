#!/bin/bash

# Collect input param
cluster_name=$1
host_user_name=$2

# In lcm_opscenter.sh
echo cluster_name = $cluster_name

##### Turn off the firewall
service firewalld stop
chkconfig firewalld off

##### Install required OS packages
yum -y update
yum -y install unzip wget
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
yum -y install python-pip
pip install requests

## Install OpsCenter
cd ~opc
if [ -f master.zip ] ; then
    rm -f master.zip
fi
wget https://github.com/DSPN/install-datastax-redhat/archive/master.zip
unzip master.zip
cd install-datastax-redhat-master/bin/
./os/install_java.sh
./opscenter/install.sh
./opscenter/start.sh


## Set up cluster in OpsCenter the LCM way
cd ~opc
wget https://github.com/DSPN/install-datastax-ubuntu/archive/5.5.0.zip
unzip 5.5.0.zip
cd install-datastax-ubuntu-5.5.0/bin/lcm/

# Retrieve OpsCenter's public IP address
private_ip=`echo $(hostname -I)`

privkey=$(readlink -f ~opc/.ssh/bmc_rsa)
sleep 1m

./setupCluster.py \
--opsc-ip $private_ip \
--clustername $cluster_name \
--privkey $privkey \
--datapath /mnt/data1 \
--user $host_user_name

