#!/bin/sh

echo "Running dse.sh"

data_center_size=$1
opscfqdn=$2
data_center_name=$3
opscpw=$4

echo "Input to dse.sh is:"
echo data_center_size $data_center_size
echo opscfqdn $opscfqdn
echo data_center_name $data_center_name
echo opscpw XXXXXX

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################"
###################### Install DSE ####################"
#######################################################"
release="7.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

cd install-datastax-ubuntu-$release/bin/

# install extra packages, openjdk
./os/extra_packages.sh
./os/install_java.sh -o

# grabbing metadata after extra_packages.sh to ensure we have jq
cluster_name="mycluster"
private_ip=`echo $(hostname -I)`
node_id=$private_ip
public_ip="127.0.0.1"

echo "Calling addNode.py with the settings:"
echo opscfqdn $opscfqdn
echo opscpw XXXXXX
echo cluster_name $cluster_name
echo data_center_size $data_center_size
echo data_center_name $data_center_name
echo rack $rack
echo public_ip $public_ip
echo private_ip $private_ip
echo node_id $node_id

./lcm/addNode.py \
--opsc-ip $opscfqdn \
--opscpw $opscpw \
--trys 120 \
--pause 10 \
--clustername $cluster_name \
--dcname $data_center_name \
--rack $rack \
--pubip $public_ip \
--privip $private_ip \
--nodeid $node_id
