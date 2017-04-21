# Output the private and public IPs of the DataStax OpsCenter instance

output "DSE_OPSC_PrivateIP" {
  value = ["${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"]
}

output "DSE_OPSC_PublicIP" {
  value = ["${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}"]
}

output "Cassandra_DB_User_Password" {
  value = ["${var.Cassandra_DB_User_Password}"]
}
