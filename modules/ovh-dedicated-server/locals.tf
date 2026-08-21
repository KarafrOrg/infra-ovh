locals {
  operating_system = "byoi_64"
  operating_system_image_url = "https://factory.talos.dev/image/09dbcadc567d93b02a1610c70d651fadbe56aeac3aaca36bc488a38f3fffe99d/v1.13.9/metal-amd64.qcow2"

  gcp_safe_labels = {
    for key, server in var.dedicated_servers :
    key => {
      for lk, lv in try(server.labels, {}) :
      lk => substr(
        replace(
          replace(lower(tostring(lv)), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]/", "_"),
          "/_+/", "_",
        ),
        0,
        63,
      )
    }
  }
}
