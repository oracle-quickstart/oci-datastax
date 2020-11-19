# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {
}

variable "compartment_ocid" {
}

variable "region" {
}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "node_shape" {
  description = "Shape for DSE nodes"
  default     = "VM.Standard2.4"
}

variable "node_count" {
  description = "Number of DSE nodes"
  default     = 3
}

variable "dse_version" {
  description = "DSE version"
  default     = "6.8.6"
}

variable "password" {
  description = "Password for DSE user 'cassandra' and OpsCenter user 'admin'"
}
