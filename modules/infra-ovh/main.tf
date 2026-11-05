locals {
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

  control_plane_ips                       = local.control_plane_ips
  worker_ips                              = local.worker_ips
  cluster_name                            = var.cluster_name
  cluster_endpoint                        = var.cluster_endpoint
  kubeconfig_secret_id                    = var.kubeconfig_secret_id
  secret_replication_automatic            = var.secret_replication_automatic
  secret_replication_locations            = var.secret_replication_locations
  talosconfig_secret_id                   = var.talosconfig_secret_id
  k8s_api_endpoint_secret_id              = var.k8s_api_endpoint_secret_id
  k8s_api_certificate_authority_secret_id = var.k8s_api_certificate_authority_secret_id
  k8s_api_client_certificate_secret_id    = var.k8s_api_client_certificate_secret_id
  k8s_api_token_secret_id                 = var.k8s_api_token_secret_id
  oidc_issuer_host                        = var.oidc_issuer_host
  cloudflare_tunnel_token_secret_id       = var.cloudflare_tunnel_token_secret_id
  installation_task_ids                   = module.ovh_dedicated_server.installation_tasks
}


module "edge_firewall" {
  source = "../ovh-edge-firewall"
  count  = var.enable_edge_firewall ? 1 : 0

  node_ips = concat(local.control_plane_ips, local.worker_ips)

  depends_on = [module.talos_cluster]
}
