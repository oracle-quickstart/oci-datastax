# Datasource resources

# Gets a list of Availability Domains
data "baremetal_identity_availability_domains" "ADs" {
    compartment_id = "${var.tenancy_ocid}"
}

# Gets the OCID of the OS image to use
data "baremetal_core_images" "OLImageOCID" {
    compartment_id = "${var.compartment_ocid}"
    operating_system = "${var.InstanceOS}"
    operating_system_version = "${var.InstanceOSVersion}"
}

# Gets a list of vNIC attachments on DSE_OPSC
data "baremetal_core_vnic_attachments" "DSE_OPSC_Vnics" {
    compartment_id = "${var.compartment_ocid}"
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    instance_id = "${baremetal_core_instance.DSE_OPSC.id}"
}

# Gets the OCID of the first (default) vNIC on DSE_OPSC
data "baremetal_core_vnic" "DSE_OPSC_Vnic" {
    vnic_id = "${lookup(data.baremetal_core_vnic_attachments.DSE_OPSC_Vnics.vnic_attachments[0],"vnic_id")}"
}

