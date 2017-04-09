resource "baremetal_core_instance" "DSE_OPSC" {
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "DSE_OPSC"
    image = "${lookup(data.baremetal_core_images.OLImageOCID.images[0], "id")}"
    shape = "${var.DSE_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(file(var.DSE_OPSC_BootStrap))}"
    }
}

