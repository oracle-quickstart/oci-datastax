variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "compartment_ocid" {}
variable "region" {}

variable "ssh_public_key" {}

variable "ssh_private_key" {}

provider "baremetal" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}

variable "InstanceOS" {
    default = "Oracle Linux"
}

variable "InstanceOSVersion" {
    default = "7.3"
}

variable "DSE_Shape" {
    default = "BM.HighIO1.36"
}

variable "VPC-CIDR" {
default = "0.0.0.0/0"
}


variable "DSE_OPSC_BootStrap" {
    default = "./userdata/node_opsc_userdata.sh"
}

variable "OPSC_BootStrap" {
    default = "./userdata/opscenter_userdata.sh"
}

variable "DSE_BootStrap" {
    default = "./userdata/node_userdata.sh"
}

variable "GML_Test" {
    default = "Hello"
}

