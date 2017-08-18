# Compute resources

resource "baremetal_core_instance" "DSE_OPSC" {
    provider = "baremetal.phx"
    depends_on = ["baremetal_core_subnet.DataStax_PublicSubnet_AD_PHX"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "OPSC_AD_1-0"
    image = "${lookup(data.baremetal_core_images.OLImageOCID_PHX.images[0], "id")}"
    shape = "${var.OPSC_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_PHX.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s %s\n",
           file(var.OPSC_BootStrap),
           "./lcm_opscenter.sh",
           "${var.DSE_Cluster_Name}",
           "${var.DSE_Cluster_Topology_PHX_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD3_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD3_Count"]}",
           "${var.host_user_name}",
           "${var.DataStax_Academy_Creds["username"]}",
           "${var.DataStax_Academy_Creds["password"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
}


resource "baremetal_core_instance" "DSE_Node_PHX_0" {
    provider = "baremetal.phx"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_PHX_1-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID_PHX.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_PHX.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-phoenix-1",
           "${var.DSE_Cluster_Topology_PHX_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.DSE_Cluster_Topology_PHX_Region["AD1_Count"]}"
}


resource "baremetal_core_instance" "DSE_Node_PHX_1" {
    provider = "baremetal.phx"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_PHX_2-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID_PHX.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_PHX.1.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-phoenix-1",
           "${var.DSE_Cluster_Topology_PHX_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.DSE_Cluster_Topology_PHX_Region["AD2_Count"]}"
}


resource "baremetal_core_instance" "DSE_Node_PHX_2" {
    provider = "baremetal.phx"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[2],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_PHX_3-%d", count.index)}" 
    image = "${lookup(data.baremetal_core_images.OLImageOCID_PHX.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_PHX.2.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-phoenix-1",
           "${var.DSE_Cluster_Topology_PHX_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_PHX_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }   
    count = "${var.DSE_Cluster_Topology_PHX_Region["AD3_Count"]}"
}


resource "baremetal_core_instance" "DSE_Node_IAD_0" {
    provider = "baremetal.iad"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.IAD_ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_IAD_1-%d", count.index)}"
    image = "${lookup(data.baremetal_core_images.OLImageOCID_IAD.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_IAD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-ashburn-1",
           "${var.DSE_Cluster_Topology_IAD_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.DSE_Cluster_Topology_IAD_Region["AD1_Count"]}"
}


resource "baremetal_core_instance" "DSE_Node_IAD_1" {
    provider = "baremetal.iad"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.IAD_ADs.availability_domains[1],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_IAD_2-%d", count.index)}"
    image = "${lookup(data.baremetal_core_images.OLImageOCID_IAD.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_IAD.1.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-ashburn-1",
           "${var.DSE_Cluster_Topology_IAD_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.DSE_Cluster_Topology_IAD_Region["AD2_Count"]}"
}


resource "baremetal_core_instance" "DSE_Node_IAD_2" {
    provider = "baremetal.iad"
    depends_on = ["baremetal_core_instance.DSE_OPSC"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.IAD_ADs.availability_domains[2],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "${format("DSE_AD_IAD_3-%d", count.index)}"
    image = "${lookup(data.baremetal_core_images.OLImageOCID_IAD.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD_IAD.2.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(format("%s\n%s %s %s %s %s %s\n",
           file(var.DSE_BootStrap),
           "./lcm_node.sh",
           "${data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address}",
           "${var.DSE_Cluster_Name}",
           "us-phoenix-1",
           "${var.DSE_Cluster_Topology_IAD_Region["AD1_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD2_Count"] +
              var.DSE_Cluster_Topology_IAD_Region["AD3_Count"]}",
           "${var.Cassandra_DB_User_Password}"
        ))}"
    }
    count = "${var.DSE_Cluster_Topology_IAD_Region["AD3_Count"]}"
}


