#!/bin/bash

cd ~opc

curl https://raw.githubusercontent.com/DSPN/oracle-bmc-terraform-dse/jump-start/userdata/lcm_opscenter.sh > lcm_opscenter.sh

chmod +x lcm_opscenter.sh

