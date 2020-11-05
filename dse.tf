resource "oci_core_instance" "dse" {
  display_name        = "dse-${count.index}"
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0]["name"]
  shape               = var.node_shape

  source_details {
    source_id   = var.images[var.region]
    source_type = "image"
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.subnet.id
    hostname_label = "dse-${count.index}"
  }

  metadata = {
    ssh_authorized_keys = join(
      "\n",
      [
        var.ssh_public_key,
        tls_private_key.ssh_key.public_key_openssh
      ]
    )

    user_data = base64encode(
      join(
        "\n",
        [
          "#!/usr/bin/env bash",
          "password=${var.password}",
          file("./scripts/dse.sh"),
        ],
      ),
    )
  }

  freeform_tags = {
    "quick-start" = "{\"Deployment\":\"TF\", \"Publisher\":\"DataStax\", \"Offer\":\"dse\",\"Licence\":\"byol\"}"
  }

  count = var.node_count
}
