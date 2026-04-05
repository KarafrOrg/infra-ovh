component "ovh-dedicated-server" {
  source = "./modules/ovh-dedicated-server"

  providers = {
    google = provider.google.main
    ovh    = provider.ovh.main
  }

  inputs = {
    gcp_project_name              = var.gcp_project_name
    ovh_credentials_secret_names  = var.ovh_credentials_secret_names
    dedicated_servers             = var.dedicated_servers
    ssh_keys                      = var.ssh_keys
    secret_prefix                 = var.secret_prefix
    secret_replication_automatic  = var.secret_replication_automatic
    secret_replication_locations  = var.secret_replication_locations
    notification_topic_prefix     = var.notification_topic_prefix
  }
}

