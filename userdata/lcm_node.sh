#!/bin/bash

##### Collecting input params
opsc_ip=$1
cluster_name=$2
data_center_name=$3
data_center_size=$4
db_passwd=$5

echo In lcm_node.sh
echo opsc_ip = $opsc_ip
echo cluster_name = $cluster_name
echo data_center_name = $data_center_name
echo data_center_size = $data_center_size

##### Turn off the firewall
service firewalld stop
chkconfig firewalld off

##### Mount disks
# Install LVM software:
yum -y update
yum -y install lvm2 dmsetup mdadm reiserfsprogs xfsprogs

# Create disk partitions for LVM:
pvcreate /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1

# Create volume group upon disk partitions:
vgcreate vg-nvme /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
lvcreate --name lv --size 11.6T vg-nvme
mkfs.ext4 /dev/vg-nvme/lv
mkdir /mnt/data1
mount /dev/vg-nvme/lv /mnt/data1
mkdir -p /mnt/data1/data
mkdir -p /mnt/data1/saved_caches
mkdir -p /mnt/data1/commitlog
chmod -R 777 /mnt/data1

##### Install DSE the LCM way 
yum -y install unzip wget
#wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
yum -y install python-pip
pip install requests

public_ip=`curl --retry 10 icanhazip.com`
private_ip=`echo $(hostname -I)`
node_id=$private_ip
rack="rack1"

cd ~opc
wget https://github.com/DSPN/install-datastax-ubuntu/archive/5.5.0.zip
unzip 5.5.0.zip
cd install-datastax-ubuntu-5.5.0/bin/lcm/

./addNode.py \
--opsc-ip $opsc_ip \
--clustername $cluster_name \
--dcsize $data_center_size \
--dcname $data_center_name \
--rack $rack \
--pubip $public_ip \
--privip $private_ip \
--nodeid $node_id \
--dbpasswd $db_passwd
