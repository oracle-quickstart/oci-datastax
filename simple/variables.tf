variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "region" {
  default = "us-ashburn-1"
}

variable "shape" {
  default = "VM.Standard1.4"
}

variable "nodeCount" {
  default = "3"
}

variable "password" {
  default = "foo123!"
}
