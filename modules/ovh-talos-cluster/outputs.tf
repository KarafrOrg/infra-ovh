output "client_configuration" {
  description = "Talos client configuration for interacting with the cluster"
  value       = talos_machine_secrets.this.client_configuration
  sensitive   = true
}

output "machine_secrets" {
  description = "Talos machine secrets"
  value       = talos_machine_secrets.this.machine_secrets
  sensitive   = true
}

output "kubeconfig_raw" {
  description = "Raw kubeconfig for the bootstrapped cluster"
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "cluster_ca_cert" {
  description = "Base64-encoded cluster CA certificate (from kubeconfig)"
  value       = local.cluster_ca_cert
  sensitive   = true
}

output "cluster_server" {
  description = "Kubernetes API server URL"
  value       = local.cluster_server
}
