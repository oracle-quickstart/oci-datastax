# BMC block storage resources

# Block stroage for OpsCenter Node
#resource "baremetal_core_volume" "TFBlock0_OPSC" {
#    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}" 
#    compartment_id = "${var.compartment_ocid}"
#    display_name = "TFBlock0"
#    size_in_mbs = "${var.2TB}"
#}

#resource "baremetal_core_volume_attachment" "TFBlock0Attach" {
#    attachment_type = "iscsi"
#    compartment_id = "${var.compartment_ocid}"
#    instance_id = "${baremetal_core_instance.DSE_OPSC.id}" 
#    volume_id = "${baremetal_core_volume.TFBlock0_OPSC.id}"
#}


# Block storage for DSE nodes in AD-1
resource "baremetal_core_volume" "TFBlock0_AD1_DSE" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}" 
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("TFBlock0_AD1_DSE-%d", count.index)}"
    size_in_mbs = "${var.2TB}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}" 
}

resource "baremetal_core_volume_attachment" "TFBlock0Attach_AD1_DSE" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${element(baremetal_core_instance.DSE_Node_0.*.id, count.index)}"
    volume_id = "${element(baremetal_core_volume.TFBlock0_AD1_DSE.*.id, count.index)}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}" 
}


# Block storage for DSE nodes in AD-2
resource "baremetal_core_volume" "TFBlock0_AD2_DSE" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("TFBlock0_AD2_DSE-%d", count.index)}"
    size_in_mbs = "${var.2TB}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}

resource "baremetal_core_volume_attachment" "TFBlock0Attach_AD2_DSE" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${element(baremetal_core_instance.DSE_Node_1.*.id, count.index)}"
    volume_id = "${element(baremetal_core_volume.TFBlock0_AD2_DSE.*.id, count.index)}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}


# Block storage for DSE nodes in AD-3
resource "baremetal_core_volume" "TFBlock0_AD3_DSE" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[2],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("TFBlock0_AD3_DSE-%d", count.index)}"
    size_in_mbs = "${var.2TB}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}

resource "baremetal_core_volume_attachment" "TFBlock0Attach_AD3_DSE" {
    attachment_type = "iscsi"
    compartment_id = "${var.compartment_ocid}"
    instance_id = "${element(baremetal_core_instance.DSE_Node_2.*.id, count.index)}"
    volume_id = "${element(baremetal_core_volume.TFBlock0_AD3_DSE.*.id, count.index)}"
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}

