# Datasource resources

# Gets a list of Availability Domains
data "baremetal_identity_availability_domains" "PHX_ADs" {
    provider = "baremetal.phx"
    compartment_id = "${var.tenancy_ocid}"
}

data "baremetal_identity_availability_domains" "IAD_ADs" {
    provider = "baremetal.iad"
    compartment_id = "${var.tenancy_ocid}"
}

# Gets the OCID of the OS image to use
data "baremetal_core_images" "OLImageOCID_PHX" {
    provider = "baremetal.phx"
    compartment_id = "${var.compartment_ocid}"
    operating_system = "${var.InstanceOS}"
    operating_system_version = "${var.InstanceOSVersion}"
}

data "baremetal_core_images" "OLImageOCID_IAD" {
    provider = "baremetal.iad"
    compartment_id = "${var.compartment_ocid}"
    operating_system = "${var.InstanceOS}"
    operating_system_version = "${var.InstanceOSVersion}"
}


# Gets a list of vNIC attachments on DSE_OPSC
data "baremetal_core_vnic_attachments" "DSE_OPSC_Vnics" {
    provider = "baremetal.phx"
    compartment_id = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.PHX_ADs.availability_domains[0],"name")}"
    instance_id = "${baremetal_core_instance.DSE_OPSC.id}"
}

# Gets the OCID of the first (default) vNIC on DSE_OPSC
data "baremetal_core_vnic" "DSE_OPSC_Vnic" {
    provider = "baremetal.phx"
    vnic_id = "${lookup(data.baremetal_core_vnic_attachments.DSE_OPSC_Vnics.vnic_attachments[0],"vnic_id")}"
}

