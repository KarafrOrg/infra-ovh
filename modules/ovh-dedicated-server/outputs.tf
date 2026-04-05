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

output "servers" {
  description = "Map of OVH dedicated servers"
  value = {
    for k, v in ovh_dedicated_server.server :
    k => {
      id           = v.id
      service_name = v.service_name
      display_name = v.display_name
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

