output "OpsCenter_URL" {
  value = ["${format("https://%s:8443", data.oci_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}
