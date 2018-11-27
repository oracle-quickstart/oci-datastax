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
variable "ssh_private_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "dse" {
  type = "map"
  default = {
    shape = "VM.Standard2.4"
    node_count = 3
    username = "admin"
    password = "admin"
    version = "6.0.2"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/67026570-4527-42f5-b483-75085379e48c/
// Canonical-Ubuntu-16.04-2018.08.15-0
variable "images" {
  type = "map"
  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa3tl3phbgdyzjba64h2tgunnwzxbxtw4r36u4ttnsn3m77t6jcurq"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa7keb3ok2deynxzsz7k5rondhuc7nt5vw6hf3q5xslyiepnqsi3aq"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaafrt5olkogiw2xn74ssu4mjnv7e2wgqkmxwuo4kqihggt74bmgpza"
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaaizzbceqxadaggbchf6yasjralcqdlh2tmgca6ag5b4gvcg4k4rha"
  }
}
