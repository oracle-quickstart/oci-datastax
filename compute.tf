resource "baremetal_core_instance" "DSE_OPSC" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DSE_OPSC_AD_0-0"
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s\n%s",
           file(var.DSE_BootStrap),
           "./node.sh",
           "${var.region}",
           file(var.OPSC_BootStrap)
        ))}"
    }
}

resource "baremetal_core_instance" "DSE_Node_0" {
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_OPSC_AD_0-%d", count.index + 1)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s",
           file(var.DSE_BootStrap),
           "./node.sh",
           "${var.region}",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"
        ))}"
    }
#    count = 3
    count = "${var.Num_DSE_Nodes_In_Each_AD - 1}"
}

resource "baremetal_core_instance" "DSE_Node_1" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_OPSC_AD_1-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.1.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s",
           file(var.DSE_BootStrap),
           "./node.sh",
           "${var.region}",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"
        ))}"
    }
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}

resource "baremetal_core_instance" "DSE_Node_2" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[2],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_OPSC_AD_2-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.2.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s",
           file(var.DSE_BootStrap),
           "./node.sh",
           "${var.region}",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}"
        ))}"
    }
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}


