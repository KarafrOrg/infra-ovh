output "dedicated_servers" {
  value = module.infra_ovh.servers
}

output "dedicated_server_info_secrets" {
  value = module.infra_ovh.server_info_secrets
}

output "talos_kubeconfig" {
  description = "Raw kubeconfig for the Talos cluster"
  value       = module.infra_ovh.talos_kubeconfig
  sensitive   = true
}

output "talos_client_configuration" {
  description = "Talos client configuration"
  value       = module.infra_ovh.talos_client_configuration
  sensitive   = true
}
