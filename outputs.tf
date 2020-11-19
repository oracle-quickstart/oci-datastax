output "opscenter_url" {
  value = "https://${data.oci_core_vnic.opscenter_vnic.public_ip_address}:8443"
}

output "lifecyclemanager_url" {
  value = "https://${data.oci_core_vnic.opscenter_vnic.public_ip_address}:8443/opscenter/lcm.html"
}

output "node_public_ips" {
  value = join(",", oci_core_instance.dse.*.public_ip)
}

output "node_private_ips" {
  value = join(",", oci_core_instance.dse.*.private_ip)
}
