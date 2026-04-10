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
  id = "ns338656.ip-5-196-78.eu"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["proxmox-master"]
}

import {
  id = "ns510634.ip-198-27-70.net"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["proxmox-node1"]
}


import {
  id = "ns3156292.ip-135-125-223.eu"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["proxmox-node3"]
}

import {
  id = "ns324588.ip-37-187-157.eu"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["proxmox-node4"]
}

import {
  id = "ns331578.ip-37-187-159.eu"
  to = module.infra_ovh.module.ovh_dedicated_server.ovh_dedicated_server.server["proxmox-node5"]
}

