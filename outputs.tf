# Output the private and public IPs of the instance

output "DSE_OPSC_PrivateIP" {
value = ["${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"]
}

