locals {
  # Extract IPs from server labels (stored as dash-separated, e.g. "198-27-70-67" → "198.27.70.67")
  control_plane_ips = [
    for k, v in var.dedicated_servers :
    replace(v.labels["ip"], "-", ".")
    if try(v.labels["role"], "") == "server"
  ]
  worker_ips = [
    for k, v in var.dedicated_servers :
    replace(v.labels["ip"], "-", ".")
    if try(v.labels["role"], "") == "agent"
  ]
}

module "ovh_dedicated_server" {
  source = "../ovh-dedicated-server"

  dedicated_servers            = var.dedicated_servers
  notification_topic_prefix    = var.notification_topic_prefix
  secret_prefix                = var.secret_prefix
  secret_replication_automatic = var.secret_replication_automatic
  secret_replication_locations = var.secret_replication_locations
  ssh_keys                     = var.ssh_keys
}

module "talos_cluster" {
  source = "../ovh-talos-cluster"

  control_plane_ips            = local.control_plane_ips
  worker_ips                   = local.worker_ips
  cluster_name                 = var.cluster_name
  cluster_endpoint             = var.cluster_endpoint
  kubeconfig_secret_id         = var.kubeconfig_secret_id
  secret_replication_automatic = var.secret_replication_automatic
  secret_replication_locations = var.secret_replication_locations
  talosconfig_secret_id        = var.talosconfig_secret_id
  installation_task_ids        = module.ovh_dedicated_server.installation_tasks
}

