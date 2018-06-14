#!/usr/bin/env bash

cd ~opc

release="6.0.6"
curl https://raw.githubusercontent.com/DSPN/oracle-bmc-terraform-dse/$release/userdata/lcm_node.sh > lcm_node.sh

chmod +x lcm_node.sh

