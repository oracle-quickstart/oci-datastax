echo "Running opscenter.sh"

echo "Got the parameters:"
echo username $username
echo password $password
echo node_count $node_count
echo version $version

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."

echo "" > /etc/iptables/rules.v4
echo "" > /etc/iptables/rules.v6

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#######################################################"
################### Install OpsCenter #################"
#######################################################"
release="7.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

export OPSC_VERSION="6.7.0"
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

./lcm/setupCluster.py \
--opscpw $password \
--clustername "mycluster" \
--repouser "datastax@oracle.com" \
--repopw "*9En9HH4j^p4" \
--dsever $version \
--username "ubuntu" \
--privkey ~/.ssh/oci \
--dsever "6.7.0" \
--dbpasswd $password \
--verbose

# trigger install
./lcm/triggerInstall.py \
--opscpw $password \
--clustername "mycluster" \
--clustersize $node_count \
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
