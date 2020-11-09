
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu_18" {
  compartment_id   = var.compartment_ocid
  operating_system = "Canonical Ubuntu"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "AVAILABLE"

  # filter restricts to 18.04
  filter {
    name   = "operating_system_version"
    values = ["18.04"]
  }
  # selects only non-Minimal images
  filter {
    name = "display_name"
    values = ["Canonical-Ubuntu-18.04-[0-9]"]
    regex = true
  }
}
