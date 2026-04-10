module "ovh_dedicated_server" {
  source = "../ovh-dedicated-server"

  dedicated_servers            = var.dedicated_servers
  notification_topic_prefix    = var.notification_topic_prefix
  secret_prefix                = var.secret_prefix
  secret_replication_automatic = var.secret_replication_automatic
  secret_replication_locations = var.secret_replication_locations
  ssh_keys                     = var.ssh_keys
}
