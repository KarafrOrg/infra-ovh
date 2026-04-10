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

import {
  id = "projects/karafra-net/secrets/ovh-server-k8s-node1-info"
  to = module.infra_ovh.module.ovh_dedicated_server.google_secret_manager_secret.server_info["k8s-node1"]
}

import {
  id = "ns338656.ip-5-196-78.eu"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["k8s-node1"]
}

import {
  id = "projects/1019265211616/secrets/ovh-server-k8s-node1-info/versions/7"
  to = module.infra_ovh.module.ovh_dedicated_server.google_secret_manager_secret_version.server_info["k8s-node1"]
}
