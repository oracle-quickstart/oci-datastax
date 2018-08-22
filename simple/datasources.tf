data "oci_identity_availability_domains" "PHX_ADs" {
  provider       = "oci.phx"
  compartment_id = "${var.tenancy_ocid}"
}

data "oci_identity_availability_domains" "IAD_ADs" {
  provider       = "oci.iad"
  compartment_id = "${var.tenancy_ocid}"
}

data "oci_core_images" "OLImageOCID_PHX" {
  provider                 = "oci"
  compartment_id           = "${var.compartment_ocid}"
  operating_system         = "CentOS"
  operating_system_version = "7"
}

data "oci_core_vnic_attachments" "DSE_OPSC_Vnics" {
  provider            = "oci.phx"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.PHX_ADs.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.DSE_OPSC.id}"
}

# Gets the OCID of the first (default) vNIC on DSE_OPSC
data "oci_core_vnic" "DSE_OPSC_Vnic" {
  provider = "oci.phx"
  vnic_id  = "${lookup(data.oci_core_vnic_attachments.DSE_OPSC_Vnics.vnic_attachments[0],"vnic_id")}"
}
