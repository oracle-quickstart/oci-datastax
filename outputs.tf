output "opscenter_url" {
  value = "http://${data.oci_core_vnic.opscenter_vnic.public_ip_address}:8888"
}

output "lifecyclemanager_url" {
  value = "http://${data.oci_core_vnic.opscenter_vnic.public_ip_address}:8888/opscenter/lcm.html"
}

output "node_public_ips" {
  value = join(",", oci_core_instance.dse.*.public_ip)
}

output "node_private_ips" {
  value = join(",", oci_core_instance.dse.*.private_ip)
}
