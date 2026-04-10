output "dedicated_servers" {
  value = module.infra_ovh.servers
}

output "dedicated_server_info_secrets" {
  value = module.infra_ovh.server_info_secrets
}
