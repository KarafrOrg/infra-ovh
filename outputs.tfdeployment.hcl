publish_output "ovh_server_info_secrets" {
  description = "Server information secrets stored in GCP Secret Manager"
  value       = component.ovh-dedicated-server.server_info_secrets
}

publish_output "ovh_ssh_key_secrets" {
  description = "SSH key secrets stored in GCP Secret Manager"
  value       = component.ovh-dedicated-server.ssh_key_secrets
}

publish_output "ovh_server_install_tasks" {
  description = "Server installation task details"
  value       = component.ovh-dedicated-server.server_install_tasks
}

publish_output "ovh_server_updates" {
  description = "Server update configurations"
  value       = component.ovh-dedicated-server.server_updates
}

publish_output "ovh_notification_topics" {
  description = "Pub/Sub topics for server monitoring notifications"
  value       = component.ovh-dedicated-server.notification_topics
}

