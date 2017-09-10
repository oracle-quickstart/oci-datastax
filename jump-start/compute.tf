# Compute resources

resource "baremetal_core_instance" "DSE_OPSC" {
    depends_on = ["baremetal_core_subnet.DataStax_PublicSubnet_AD"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "OPSC_AD_1-0"
    image = "${var.OPSC_BASE_IMAGE_ID}"
    shape = "${var.OPSC_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s\n",
           file(var.OPSC_BootStrap),
           "./lcm_opscenter.sh",
           "${var.DSE_Cluster_Name}",
           "${var.host_user_name}",
           "${var.DataStax_Academy_Creds["username"]}",
           "${var.DataStax_Academy_Creds["password"]}"
        ))}"
    }
}


resource "baremetal_core_instance" "DSE_Node_0" {
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_1-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}",
           "${var.DSE_Cluster_Name}",
           "${var.region}",
           "${var.Num_DSE_Nodes_In_Each_AD * 3}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    create_vnic_details {
        subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
        display_name = "vnicdname"
        private_ip = "10.0.0.8"
        assign_public_ip = true
    }
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}


resource "baremetal_core_instance" "DSE_Node_1" {
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_2-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.1.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}",
           "${var.DSE_Cluster_Name}",
           "${var.region}",
           "${var.Num_DSE_Nodes_In_Each_AD * 3}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}


resource "baremetal_core_instance" "DSE_Node_2" {
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[2],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_3-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.2.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.private_ip_address}",
           "${var.DSE_Cluster_Name}",
           "${var.region}",
           "${var.Num_DSE_Nodes_In_Each_AD * 3}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }    
    count = "${var.Num_DSE_Nodes_In_Each_AD}"
}



