#!/usr/bin/env bash

##### First argument contains the BMC region for provisioning
region=$1

##### Second argument contains seed_plus_opscenter_node_ip if provided

##### Turn off the firewall

service firewalld stop
chkconfig firewalld off

##### Mount disks

# Install LVM software:
yum -y install lvm2 dmsetup mdadm reiserfsprogs xfsprogs

# Create disk partitions for LVM:
pvcreate /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1

# Create volume group upon disk partitions:
vgcreate vg-nvme /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
lvcreate --name lv --size 11.6T vg-nvme
mkfs.ext4 /dev/vg-nvme/lv
mkdir /mnt/data1
mount /dev/vg-nvme/lv /mnt/data1
chmod 777 /mnt/data1



##### Installing DataStax Node

# Retrieve local IP address
local_ip=
while IFS=$': \t' read -a line ;do
    [ -z "${line%inet}" ] && ip=${line[${#line[1]}>4?1:2]} &&
        [ "${ip#127.0.0.1}" ] && local_ip=$ip
  done< <(LANG=C /sbin/ifconfig)

cd /home/opc
curl -o master.zip https://codeload.github.com/DSPN/install-datastax-redhat/zip/master
yum -y install unzip
unzip master.zip
cd install-datastax-redhat-master/bin

# if seed_plus_opscenter_node_ip is not defined then pass local_ip, else pass seed_plus_opscenter_node_ip
if [ -z "$2" ]
  then
    ./dse.sh bmc $local_ip $region $local_ip
  else
    ./dse.sh bmc $2 $region $2
fi

