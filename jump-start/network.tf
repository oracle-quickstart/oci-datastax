# Network resources

resource "baremetal_core_virtual_network" "DataStax_VCN" {
  cidr_block = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name = "DataStax_VCN"
}


resource "baremetal_core_internet_gateway" "DataStax_IG" {
    depends_on = ["baremetal_core_virtual_network.DataStax_VCN"]
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_IG"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN.id}"
}


resource "baremetal_core_route_table" "DataStax_RT" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN.id}"
    display_name = "DataStax_RT"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${baremetal_core_internet_gateway.DataStax_IG.id}"
    }
}


resource "baremetal_core_security_list" "DataStax_PublicSubnet" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "DataStax_PublicSubnet"
    vcn_id = "${baremetal_core_virtual_network.DataStax_VCN.id}"
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
            "max" = 9091
            "min" = 9091
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


resource "baremetal_core_subnet" "DataStax_PublicSubnet_AD" {
  availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block = "${format("10.0.%d.0/24", count.index)}"
  display_name = "${format("PublicSubnetAD-%d", count.index)}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${baremetal_core_virtual_network.DataStax_VCN.id}"
  route_table_id = "${baremetal_core_route_table.DataStax_RT.id}"
  security_list_ids = ["${baremetal_core_security_list.DataStax_PublicSubnet.id}"]
  dhcp_options_id = "${baremetal_core_virtual_network.DataStax_VCN.default_dhcp_options_id}"
  count = 3
}

