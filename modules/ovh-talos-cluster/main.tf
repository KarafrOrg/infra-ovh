locals {
  all_ips          = concat(var.control_plane_ips, var.worker_ips)
  cluster_endpoint = coalesce(var.cluster_endpoint, var.control_plane_ips[0])
}

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
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${local.cluster_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each                    = toset(var.control_plane_ips)
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.value

  depends_on = [data.network_port_wait.talos_api]
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = toset(var.worker_ips)
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value

  depends_on = [data.network_port_wait.talos_api]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_configuration_apply.control_plane]
}

data "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_ips[0]

  depends_on = [talos_machine_bootstrap.this]
}
