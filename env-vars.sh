#!/bin/sh

# Authentication details
export TF_VAR_tenancy_ocid="<Tenancy OCID>"
export TF_VAR_user_ocid="<User OCID>"
export TF_VAR_fingerprint="<PEM key fingerprint>"
export TF_VAR_private_key_path="<path to the private key that matches the fingerprint above>"

# Compartment
export TF_VAR_compartment_ocid="<compartment OCID>"

# BMC Region: ex, us-phoenix-1
export TF_VAR_region="us-phoenix-1"
export TF_VAR_region="us-ashburn-1"

# Public/private keys used on the instance
export TF_VAR_ssh_public_key=$(cat /Users/gilbertlau/.ssh/bmc_rsa.pub)
export TF_VAR_ssh_private_key_path="/Users/gilbertlau/.ssh/bmc_rsa"
export TF_VAR_ssh_private_key=$(cat /Users/gilbertlau/.ssh/bmc_rsa)
