#!/usr/bin/env bash

cd /home/opc

curl https://raw.githubusercontent.com/DSPN/oracle-bare-metal-cloud-dse/master/extensions/node.sh > node.sh

chmod +x node.sh

./node.sh "gml"

curl https://raw.githubusercontent.com/DSPN/oracle-bare-metal-cloud-dse/master/extensions/opscenter.sh > opscenter.sh

chmod +x opscenter.sh

./opscenter.sh bmc
