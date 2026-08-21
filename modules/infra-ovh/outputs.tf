output "server_info_secrets" {
  value = module.ovh_dedicated_server.server_info_secrets
}

output "servers" {
  value = module.ovh_dedicated_server.servers
}

output "talos_kubeconfig" {
  description = "Raw kubeconfig for the Talos cluster"
  value       = module.talos_cluster.kubeconfig_raw
  sensitive   = true
}

output "talos_client_configuration" {
  description = "Talos client configuration"
  value       = module.talos_cluster.client_configuration
  sensitive   = true
}
