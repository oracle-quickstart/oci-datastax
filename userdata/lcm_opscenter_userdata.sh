#!/bin/bash

cd ~opc

release="6.0.5"
curl https://raw.githubusercontent.com/DSPN/oracle-bmc-terraform-dse/$release/userdata/lcm_opscenter.sh > lcm_opscenter.sh

chmod +x lcm_opscenter.sh

