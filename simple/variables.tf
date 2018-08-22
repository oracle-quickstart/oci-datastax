variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}


variable "shape" {
  default = "VM.Standard1.2"
}

variable "nodeCount" {
  default = "3"
}

variable "password" {
  default = "foo123!"
}
