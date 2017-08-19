# Network resources

# PHX (Phoenix region)

resource "baremetal_core_virtual_network" "DataStax_VCN_PHX" {
    provider = "baremetal.phx"
    cidr_block = "10.0.0.0/16"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_VCN-PHX"
    dns_label = "vcnwest" 
}


resource "baremetal_core_internet_gateway" "DataStax_IG_PHX" {
    provider = "baremetal.phx"
    depends_on = ["baremetal_core_virtual_network.DataStax_VCN_PHX"]
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_IG_PHX"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_PHX.id}"
}


resource "baremetal_core_route_table" "DataStax_RT_PHX" {
    provider = "baremetal.phx"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_PHX.id}"
    display_name = "DataStax_RT_PHX"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${baremetal_core_internet_gateway.DataStax_IG_PHX.id}"
    }
}


resource "baremetal_core_security_list" "DataStax_PublicSubnet_PHX" {
    provider = "baremetal.phx"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_PublicSubnet_Security_List_PHX"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_PHX.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    ingress_security_rules = [{
        icmp_options {
            "type" = 3
            "code" = 4
        }
        protocol = "1"
        source = "0.0.0.0/0"
    },
        {
        icmp_options {
            "type" = 3
        }
        protocol = "1"
        source = "10.0.0.0/16"
    },
        {
        tcp_options {
            "max" = 22 
            "min" = 22
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
	{
        tcp_options {
            "max" = 443
            "min" = 443
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7001
            "min" = 7000 
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7199
            "min" = 7199
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },

        {
        tcp_options {
            "max" = 8443
            "min" = 8443
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8888
            "min" = 8888
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9042
            "min" = 9042
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9160
            "min" = 9160
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8983
            "min" = 8983
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8609
            "min" = 8609
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7077
            "min" = 7077
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7081
            "min" = 7080
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8182
            "min" = 8182
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 5599
            "min" = 5598
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 4040
            "min" = 4040
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8090
            "min" = 8090
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9999
            "min" = 9999
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 61621
            "min" = 61620
        }
        protocol = "6"
        source = "0.0.0.0/0"
    }]
}


resource "baremetal_core_subnet" "DataStax_PublicSubnet_AD_PHX" {
    provider = "baremetal.phx"
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[count.index],"name")}"
    cidr_block = "${format("10.0.%d.0/24", count.index)}"
    display_name = "${format("PublicSubnetAD_PHX-%d", count.index)}"
    dns_label = "${format("dsesubnet%d", count.index)}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_PHX.id}"
    route_table_id = "${baremetal_core_route_table.DataStax_RT_PHX.id}"
    security_list_ids = ["${baremetal_core_security_list.DataStax_PublicSubnet_PHX.id}"]
    dhcp_options_id = "${baremetal_core_virtual_network.DataStax_VCN_PHX.default_dhcp_options_id}"
    count = 3
}



# IAD (Ashburn region)

resource "baremetal_core_virtual_network" "DataStax_VCN_IAD" {
    provider = "baremetal.iad"
    cidr_block = "10.0.0.0/16"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_VCN-IAD"
    dns_label = "vcneast"
}


resource "baremetal_core_internet_gateway" "DataStax_IG_IAD" {
    provider = "baremetal.iad"
    depends_on = ["baremetal_core_virtual_network.DataStax_VCN_IAD"]
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_IG_IAD"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_IAD.id}"
}


resource "baremetal_core_route_table" "DataStax_RT_IAD" {
    provider = "baremetal.iad"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_IAD.id}"
    display_name = "DataStax_RT_IAD"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${baremetal_core_internet_gateway.DataStax_IG_IAD.id}"
    }
}


resource "baremetal_core_security_list" "DataStax_PublicSubnet_IAD" {
    provider = "baremetal.iad"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_PublicSubnet_Security_List_IAD"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_IAD.id}"
    egress_security_rules = [{
        destination = "0.0.0.0/0"
        protocol = "6"
    }]
    ingress_security_rules = [{
        icmp_options {
            "type" = 3
            "code" = 4
        }
        protocol = "1"
        source = "0.0.0.0/0"
    },
        {
        icmp_options {
            "type" = 3
        }
        protocol = "1"
        source = "10.0.0.0/16"
    },
        {
        tcp_options {
            "max" = 22
            "min" = 22
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 443
            "min" = 443
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7001
            "min" = 7000
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7199
            "min" = 7199
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },

        {
        tcp_options {
            "max" = 8443
            "min" = 8443
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8888
            "min" = 8888
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9042
            "min" = 9042
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9160
            "min" = 9160
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8983
            "min" = 8983
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8609
            "min" = 8609
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7077
            "min" = 7077
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 7081
            "min" = 7080
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8182
            "min" = 8182
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 5599
            "min" = 5598
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 4040
            "min" = 4040
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 8090
            "min" = 8090
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 9999
            "min" = 9999
        }
        protocol = "6"
        source = "0.0.0.0/0"
    },
        {
        tcp_options {
            "max" = 61621
            "min" = 61620
        }
        protocol = "6"
        source = "0.0.0.0/0"
    }]
}


resource "baremetal_core_subnet" "DataStax_PublicSubnet_AD_IAD" {
    provider = "baremetal.iad"
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.IAD_ADs.availability_domains[count.index],"name")}"
    cidr_block = "${format("10.0.%d.0/24", count.index)}"
    display_name = "${format("PublicSubnetAD_IAD-%d", count.index)}"
    dns_label = "${format("dsesubnet%d", count.index)}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN_IAD.id}"
    route_table_id = "${baremetal_core_route_table.DataStax_RT_IAD.id}"
    security_list_ids = ["${baremetal_core_security_list.DataStax_PublicSubnet_IAD.id}"]
    dhcp_options_id = "${baremetal_core_virtual_network.DataStax_VCN_IAD.default_dhcp_options_id}"
    count = 3
}





