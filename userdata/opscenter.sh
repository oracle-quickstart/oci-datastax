#!/usr/bin/env bash

# Installing DataStax OpsCenter

cloud_type=$1


# Retrieve local ip address
local_ip=
while IFS=$': \t' read -a line ;do
    [ -z "${line%inet}" ] && ip=${line[${#line[1]}>4?1:2]} &&
        [ "${ip#127.0.0.1}" ] && local_ip=$ip
  done< <(LANG=C /sbin/ifconfig)

echo "Input to opscenter.sh is:"
echo cloud_type $cloud_type
echo seed_node_ip $local_ip


# Will point to a specific release
cd /home/opc
curl -o master.zip https://codeload.github.com/DSPN/install-datastax-redhat/zip/master
yum -y install unzip
unzip master.zip
cd install-datastax-redhat-master/bin

./opscenter.sh $cloud_type $local_ip


