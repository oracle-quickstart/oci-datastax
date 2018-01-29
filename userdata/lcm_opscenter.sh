#!/bin/bash

# Collect input param
cluster_name=$1
cluster_size=$2
num_dcs=$3 
host_user_name=$4
dsa_username=$5
dsa_password=$6
db_pwd=$7
opsc_admin_pwd=$8

# In lcm_opscenter.sh
echo cluster_name = $cluster_name

##### Turn off the firewall
service firewalld stop
chkconfig firewalld off

##### Install required OS packages
yum -y update
yum -y install unzip wget
#wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
yum -y install python-pip
pip install requests

## Install OpsCenter
cd ~opc
release="6.0.4"
wget https://github.com/DSPN/install-datastax-redhat/archive/$release.zip
unzip $release.zip
cd install-datastax-redhat-$release/bin/
./os/install_java.sh
./opscenter/install.sh
./opscenter/configure_opscenterd_conf.sh
./opscenter/start.sh


## Set up cluster in OpsCenter the LCM way
cd ~opc
release="6.0.4"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.zip
unzip $release.zip
cd install-datastax-ubuntu-$release/bin/lcm/

# Retrieve OpsCenter's public IP and private IP addresses
public_ip=`curl --retry 10 icanhazip.com`
private_ip=`echo $(hostname -I)`

privkey=$(readlink -f ~opc/.ssh/bmc_rsa)
sleep 1m

./setupCluster.py \
--user $host_user_name \
--pause 60 \
--trys 40 \
--opsc-ip $public_ip \
--clustername $cluster_name \
--privkey $privkey \
--datapath /mnt/data1 \
--repouser $dsa_username \
--repopw $dsa_password

./triggerInstall.py \
--opsc-ip $public_ip \
--clustername $cluster_name \
--clustersize $cluster_size \
--dbpasswd $db_pwd \
--dclevel

./waitForJobs.py \
--num $num_dcs \
--opsc-ip $public_ip

# Alter required keyspaces for multi-DC
./alterKeyspaces.py

# Update OpsCenter Admin's password
cd ../opscenter
./set_opsc_pw_https.sh $opsc_admin_pwd


