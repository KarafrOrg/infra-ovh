data "network_port_wait" "talos_api" {
  for_each         = toset(local.all_ips)
  host             = each.value
  port             = 50000
  timeout_sec      = 3600
  error_on_timeout = true
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control_plane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${local.cluster_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    yamlencode({
      cluster = {
        apiServer = {
          extraArgs = {
            "anonymous-auth" = "true"
          }
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${local.cluster_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "terraform_data" "installation_task" {
  for_each = var.installation_task_ids

  input = each.value
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each                    = toset(var.control_plane_ips)
  client_configuration        = sensitive(talos_machine_secrets.this.client_configuration)
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.value

  depends_on = [data.network_port_wait.talos_api]

  lifecycle {
    replace_triggered_by = [
      terraform_data.installation_task
    ]
  }
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = toset(var.worker_ips)
  client_configuration        = sensitive(talos_machine_secrets.this.client_configuration)
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value

  depends_on = [data.network_port_wait.talos_api]

  lifecycle {
    replace_triggered_by = [
      terraform_data.installation_task
    ]
  }
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = sensitive(talos_machine_secrets.this.client_configuration)
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_configuration_apply.control_plane]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = sensitive(talos_machine_secrets.this.client_configuration)
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_bootstrap.this]
}

resource "google_secret_manager_secret" "kubeconfig" {
  count     = var.kubeconfig_secret_id != null ? 1 : 0
  secret_id = var.kubeconfig_secret_id

  labels = {
    managed_by   = "terraform"
    cluster_name = var.cluster_name
  }

  replication {
    dynamic "auto" {
      for_each = var.secret_replication_automatic ? [1] : []
      content {}
    }

    dynamic "user_managed" {
      for_each = var.secret_replication_automatic ? [] : [1]
      content {
        dynamic "replicas" {
          for_each = var.secret_replication_locations
          content {
            location = replicas.value
          }
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "kubeconfig" {
  count                 = var.kubeconfig_secret_id != null ? 1 : 0
  secret                = google_secret_manager_secret.kubeconfig[0].id
  secret_data           = talos_cluster_kubeconfig.this.kubeconfig_raw
  is_secret_data_base64 = false
  deletion_policy       = "ABANDON"
}
