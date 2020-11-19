echo "Running opscenter.sh"

echo "Got the parameters:"
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
release="7.3.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

export OPSC_VERSION="6.8.6"
cd install-datastax-ubuntu-$release/bin
./os/extra_packages.sh
./os/install_java.sh -o
./opscenter/install.sh 'oracle'

#######################################################"
################# Configure the Cluster ###############"
#######################################################"

# inline https/pw setup
trys=20
sleep='10s'

cp /etc/opscenter/opscenterd.conf /etc/opscenter/opscenterd.conf.bak
echo "Turn on OpsC auth"
sed -i 's/enabled = False/enabled = True/g' /etc/opscenter/opscenterd.conf

echo "Turn on SSL/agent SSL"
sed -i '0,/#ssl_keyfile/{s/#ssl_keyfile/ssl_keyfile/g}' /etc/opscenter/opscenterd.conf
sed -i '0,/#ssl_certfile/{s/#ssl_certfile/ssl_certfile/g}' /etc/opscenter/opscenterd.conf
sed -i 's/#ssl_port/ssl_port/g' /etc/opscenter/opscenterd.conf
# agent ssl config 
# note: ssl_keyfile|certfile appears twice in .conf, missing required comment in?
#sed -i 's/#use_ssl = true/use_ssl = True/g' /etc/opscenter/opscenterd.conf
#sed -i 's/#agent_keyfile/agent_keyfile/g' /etc/opscenter/opscenterd.conf
#sed -i 's/#agent_keyfile_raw/agent_keyfile_raw/g' /etc/opscenter/opscenterd.conf
#sed -i 's/#agent_certfile/agent_certfile/g' /etc/opscenter/opscenterd.conf


echo "Start OpsC"
service opscenterd restart

if [ -z $password ]; then
  echo "No pw arg, leaving default pw, exiting"
  exit 0
fi

echo "Connect to OpsC after start..."

for i in `seq 1 $trys`;
do
  echo "Attempt $i..."
  json=$(curl --retry 10 -k -s -X POST -d '{"username":"admin","password":"admin"}' 'https://localhost:8443/login')
  RET=$?

  if [[ $json == *"sessionid"* ]]; then
    echo "sessionid retrieved"
    break
  fi

  if [ $RET -eq 0 ]
  then
    echo -e "\nUnexpected response: $json"
    continue
  fi

  if [ $i -eq $trys ]
  then
    echo "Failure after 10 trys, revert to original config, restart opscenterd, and exit"
    cp /etc/opscenter/opscenterd.conf.bak /etc/opscenter/opscenterd.conf
    service opscenterd restart
    exit 1
  fi

  sleep $sleep
done

token=$(echo $json | tr -d '{} ' | awk -F':' {'print $2'} | tr -d '"')
curl -s -k -H 'opscenter-session: '$token -H 'Accept: application/json' -d '{"password": "'$password'", "old_password": "admin" }' -X PUT https://localhost:8443/users/admin

sleep 1m

./lcm/setupCluster.py \
--opscpw $password \
--clustername "mycluster" \
--repouser "datastax@oracle.com" \
--repopw "*9En9HH4j^p4" \
--dsever $version \
--username "ubuntu" \
--privkey ~/.ssh/oci \
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
