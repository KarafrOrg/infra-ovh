locals {
  operating_system = "ubuntu2404-server_64"

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
