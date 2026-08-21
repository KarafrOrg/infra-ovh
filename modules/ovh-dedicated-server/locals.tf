locals {
  operating_system = "byoi_64"
  operating_system_image_url = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.13.9/metal-amd64.qcow2"

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
