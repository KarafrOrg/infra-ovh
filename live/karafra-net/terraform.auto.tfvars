# OVH configuration
ovh_endpoint           = "ovh-ca"

# Dedicated servers configuration
dedicated_servers = {
  "proxmox-node1" = {
    existing_server = true
    monitoring      = true
    state           = "ok"
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns510634-ip-198-27-70-net"
      ip               = "198-27-70-67"
      commercial_range = "ks-le-1"
      datacenter       = "ca-east-bhs"
    }
  },
  "proxmox-node3" = {
    existing_server = true
    monitoring      = true
    state           = "ok"
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns3156292-ip-135-125-223-eu"
      ip               = "135-125-223-213"
      commercial_range = "sys-1"
      datacenter       = "eu-west-lim"
    }
  },
  "proxmox-node5" = {
    existing_server = true
    monitoring      = true
    state           = "ok"
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns331578-ip-37-187-159-eu"
      ip               = "37-187-159-125"
      commercial_range = "rise-s"
      datacenter       = "eu-west-gra"
    }
  },
}

# Secret Manager configuration
secret_prefix                = "ovh-server"
secret_replication_automatic = true
secret_replication_locations = ["europe-west1", "europe-west3"]

# Notification configuration
notification_topic_prefix = "ovh-server-monitoring"
