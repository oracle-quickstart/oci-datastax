# Output the private and public IPs of the DataStax OpsCenter instance


output "OpsCenter_URL" {
  value = ["${format("%s:8888", data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}

output "DataStax_Studio_URL" {
  value = ["${format("%s:9091", data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}

output "DSE_Solr_Admin_URL" {
  value = ["${format("%s:8983/solr", data.baremetal_core_vnic.DSE_Node_0_Vnic.public_ip_address)}"]
}

output "DSE_AD_1-0_NODE_EXTERNAL_IP" {
  value = ["${data.baremetal_core_vnic.DSE_Node_0_Vnic.public_ip_address}"]
} 

output "Cassandra_DB_User_Password" {
  value = ["${var.Cassandra_DB_User_Password}"]
}
