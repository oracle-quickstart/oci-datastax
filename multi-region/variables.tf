# Terraform variables

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "compartment_ocid" {}
variable "region" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "regions" {
    default = ["us-phoenix-1", "us-ashburn-1"]
}

variable "InstanceOS" {
    default = "Oracle Linux"
}

variable "InstanceOSVersion" {
    default = "7.3"
}

variable "DSE_Shape" {
    default = "VM.DenseIO1.8"
#   default = "VM.DenseIO1.16"
}

variable "OPSC_Shape" {
    default = "VM.Standard1.4"
}

variable "2TB" {
    default = "2097152"
}

variable "host_user_name" {
    default = "opc"
}

variable "OPSC_BootStrap" {
    default = "./userdata/lcm_opscenter_userdata.sh"
}

variable "DSE_BootStrap" {
    default = "./userdata/lcm_node_userdata.sh"
}

# DSE cluster name
variable "DSE_Cluster_Name" {
   default = "mycluster"
}

# DataStax Academy Credentials for DSE software download
variable "DataStax_Academy_Creds" {
  type = "map"

  default = {
    username = "datastax@google.com"
    password = "8GdeeVT2s7zi"
  }
}

# DSE cluster deployment topology by availability domain
variable "DSE_Cluster_Topology_PHX_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "0"
    AD3_Count = "0"
  }
}

# DSE cluster deployment topology by availability domain
variable "DSE_Cluster_Topology_IAD_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "0"
    AD3_Count = "0"
  }
}

# Collect user provided password for "cassandra" superuser
variable "Cassandra_DB_User_Password" {
  default = "datastax1!" 
}

