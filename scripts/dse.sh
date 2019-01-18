echo "Running dse.sh"

echo "Got the parameters:"
echo password $password

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
##################### Configure DSE ###################"
#######################################################"
release="7.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

cd install-datastax-ubuntu-$release/bin/

# install extra packages, openjdk
./os/extra_packages.sh

opscenterDNS="opscenter.datastax.datastax.oraclevcn.com"
nodeID=$(hostname)
privateIP=$(hostname -I)
publicIP=`curl --retry 10 icanhazip.com`

echo "Using the settings:"
echo opscenterDNS \'$opscenterDNS\'
echo nodeID \'$nodeID\'
echo privateIP \'$privateIP\'
echo publicIP \'$publicIP\'

./lcm/addNode.py \
--opsc-ip $opscenterDNS \
--opscpw $password \
--trys 120 \
--pause 10 \
--clustername "mycluster" \
--dcname "dc1" \
--rack "rack1" \
--pubip $publicIP \
--privip $privateIP \
--nodeid $nodeID
