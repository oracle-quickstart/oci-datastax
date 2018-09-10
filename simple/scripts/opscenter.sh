#!/bin/sh

echo "Running opscenter.sh"

username="admin"
password="admin"
nodecount="3"
version="6.0.2"

echo "Got the parameters:"
echo username $username
echo password $password
echo nodecount $nodecount
echo version $version

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################"
################### Install OpsCenter #################"
#######################################################"
release="7.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

cd install-datastax-ubuntu-$release/bin
./os/extra_packages.sh
./os/install_java.sh -o
./opscenter/install.sh 'oracle'

#######################################################"
################# Configure the Cluster ###############"
#######################################################"

# Turn on https and set the password for OpsCenter user admin
./opscenter/set_opsc_pw_https.sh $password
sleep 1m

cluster_name="mycluster"

./lcm/setupCluster.py \
--opscpw $password \
--clustername $cluster_name \
--repouser "datastax@oracle.com" \
--repopw "*9En9HH4j^p4" \
--dsever  $version \
--user $username \
--password $password \
--dbpasswd $password \
--datapath "/data/cassandra" \
--nojava \
--verbose

# trigger install
./lcm/triggerInstall.py \
--opscpw $password \
--clustername $cluster_name \
--clustersize $nodecount \
--pause 10 \
--trys 400

# Block execution while waiting for jobs to
# exit RUNNING/PENDING status
./lcm/waitForJobs.py \
--opscpw $password

# set keyspaces to NetworkTopology / RF 3
echo "Backgrounding call to alterKeyspaces.py, writing ouput to repair.log... "
nohup ./lcm/alterKeyspaces.py \
--opscpw $password \
--delay 60 >> ../../repair.log &
