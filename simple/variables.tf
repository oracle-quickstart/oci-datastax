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
  default = "CentOS"
}

variable "InstanceOSVersion" {
  default = "7"
}

variable "DSE_Shape" {
  default = "VM.DenseIO1.8"
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

variable "DSE_Cluster_Name" {
  default = "mycluster"
}

# DataStax Academy Credentials for DSE software download
variable "DataStax_Academy_Creds" {
  type = "map"

  default = {
    username = "datastax@oracle.com"
    password = "*9En9HH4j^p4"
  }
}

# Collect user provided password for "cassandra" superuser
variable "Cassandra_DB_User_Password" {
  default = "datastax1!"
}

# Collect user provided password for OpsCenter Admin
variable "OpsCenter_Admin_Password" {
  default = "opscenter1!"
}

# DSE cluster deployment topology by availability domain (Phoenix region: PHX)
variable "DSE_Cluster_Topology_PHX_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "1"
    AD3_Count = "1"
  }
}

# DSE cluster deployment topology by availability domain (Ashburn region: IAD)
variable "DSE_Cluster_Topology_IAD_Region" {
  type = "map"

  default = {
    AD1_Count = "1"
    AD2_Count = "1"
    AD3_Count = "1"
  }
}
