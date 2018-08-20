# Output the private and public IPs of the DataStax OpsCenter instance

output "OpsCenter_URL" {
  value = ["${format("https://%s:8443", data.oci_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}

output "OpsCenter_Admin_Password" {
  value = ["${var.OpsCenter_Admin_Password}"]
}

output "Cassandra_DB_User_Password" {
  value = ["${var.Cassandra_DB_User_Password}"]
}
