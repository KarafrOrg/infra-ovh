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

output "talos_cluster_server" {
  description = "Kubernetes API server URL"
  value       = module.talos_cluster.cluster_server
}

output "talos_cluster_ca_cert" {
  description = "Base64-encoded cluster CA certificate"
  value       = module.talos_cluster.cluster_ca_cert
  sensitive   = true
}
