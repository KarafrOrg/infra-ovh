module "infra_ovh" {
  source                       = "../../modules/infra-ovh"
  ovh_application_key          = var.ovh_application_secret
  ovh_application_secret       = var.ovh_application_secret
  ovh_consumer_key             = var.ovh_consumer_key
  ovh_endpoint                 = var.ovh_endpoint
  dedicated_servers            = var.dedicated_servers
  notification_topic_prefix    = var.notification_topic_prefix
  secret_prefix                = var.secret_prefix
  secret_replication_automatic = var.secret_replication_automatic
  secret_replication_locations = var.secret_replication_locations
  ssh_keys                     = var.ssh_keys
}
