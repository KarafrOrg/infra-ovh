locals {
  operating_system = "byoi_64"
  operating_system_image_url = "https://factory.talos.dev/image/23eaffb1b1dc915c93b270a4feb66f9841c459d8e9f8e6c591762b6c0d148e43/v1.13.9/metal-amd64.qcow2"

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
