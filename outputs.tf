# Output the private and public IPs of the instance

output "DSE_OPSC_PrivateIP" {
value = ["${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"]
}

output "String Concat" {
value = "${format("%s \n%s %s %s", 
           file(var.DSE_BootStrap), 
           "./node.sh",
           "${var.region}",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}" 
        )}"
}


output "GML_Test" {
value = "${var.GML_Test}"
}
