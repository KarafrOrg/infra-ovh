output "server_info_secrets" {
  description = "Map of server information secrets in GCP Secret Manager"
  value = {
    for k, v in google_secret_manager_secret.server_info :
    k => {
      secret_id = v.secret_id
      name      = v.name
      id        = v.id
    }
  }
}

output "ssh_key_secrets" {
  description = "Map of SSH key secrets in GCP Secret Manager"
  value = {
    for k, v in google_secret_manager_secret.ssh_keys :
    k => {
      secret_id = v.secret_id
      name      = v.name
      id        = v.id
    }
  }
}

output "server_install_tasks" {
  description = "Map of server installation task IDs"
  value = {
    for k, v in ovh_dedicated_server_install_task.server_install :
    k => {
      id           = v.id
      service_name = v.service_name
      status       = try(v.status, null)
    }
  }
}

output "server_updates" {
  description = "Map of server update configurations"
  value = {
    for k, v in ovh_dedicated_server_update.server_update :
    k => {
      id           = v.id
      service_name = v.service_name
      boot_id      = v.boot_id
      monitoring   = v.monitoring
      state        = v.state
    }
  }
}

output "notification_topics" {
  description = "Map of Pub/Sub topics for server notifications"
  value = {
    for k, v in google_pubsub_topic.server_notifications :
    k => {
      name = v.name
      id   = v.id
    }
  }
}

