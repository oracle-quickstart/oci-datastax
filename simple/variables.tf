# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "dse" {
  type = "map"
  default = {
    shape = "VM.Standard1.4"
    node_count = 3
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/c28dc7c4-f901-494c-a72b-b56eafdf0572/
// Canonical-Ubuntu-16.04-Gen2-GPU-2018.08.15-0
variable "images" {
  type = "map"
  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaagofslmfxshjjdvny7vpdbqwmvwxj6zritliwd6k37d5azjljwafq"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaapmjxgjo7zjfmsxy3qalalgrh3sm7aw4u6npzvmtpetsogkyuaisq"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaawwk3dbrs7kadsdbtf7k7prehyzpemmomzoejlcpryazu4ax437kq"
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaaked3fo6fy6stwhcwvsvxsn5ul6m3rr2ilfouu2bkwckcmcvbyu3a"
  }
}
