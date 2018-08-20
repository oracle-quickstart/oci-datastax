# remote-exec resources

resource "null_resource" "remote-exec" {
    depends_on = ["oci_core_instance.DSE_OPSC"]

    provisioner "file" {
      connection {
        agent = false
        timeout = "10m"
        host = "${data.oci_core_vnic.DSE_OPSC_Vnic.public_ip_address}"
        user = "${var.host_user_name}"
        private_key = "${var.ssh_private_key}"
      }
      source      = "<ssh_private_key_path>"
      destination = "/home/opc/.ssh/bmc_rsa"
    }

    provisioner "remote-exec" {
      connection {
        agent = false
        timeout = "10m"
        host = "${data.oci_core_vnic.DSE_OPSC_Vnic.public_ip_address}"
        user = "${var.host_user_name}"
        private_key = "${var.ssh_private_key}"
      }
      inline = [
        "chmod 600 /home/opc/.ssh/bmc_rsa"
      ]
    }
}

