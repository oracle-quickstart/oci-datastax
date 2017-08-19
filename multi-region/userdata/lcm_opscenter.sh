#!/bin/bash

# Collect input param
cluster_name=$1
cluster_size=$2
host_user_name=$3
dsa_username=$4
dsa_password=$5
db_pwd=$6

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
release="5.5.6"
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


