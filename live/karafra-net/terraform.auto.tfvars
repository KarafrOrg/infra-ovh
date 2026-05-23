# OVH configuration
ovh_endpoint           = "ovh-ca"

# Dedicated servers configuration
dedicated_servers = {
  openstack-node1 = {
    existing_server = true
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns510634-ip-198-27-70-net"
      ip               = "198-27-70-67"
      commercial_range = "ks-le-1"
      datacenter       = "ca-east-bhs"
    }
  },
  openstack-node2 = {
    existing_server = true
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns3101879-ip-54-36-168-eu"
      ip               = "54-36-168-182"
      commercial_range = "ks-le-2"
      datacenter       = "eu-central-waw-a"
    }
  },
  openstack-node3 = {
    existing_server = true
    ssh_key_secret  = "ovh-vps-ssh-public-key"
    labels = {
      service_name     = "ns3104389-ip-54-36-168-eu"
      ip               = "54-36-168-254"
      commercial_range = "ks-le-2"
      datacenter       = "eu-central-waw-a"
    }
  },
}

# Secret Manager configuration
secret_prefix                = "ovh-server"
secret_replication_automatic = true
secret_replication_locations = ["europe-west1", "europe-west3"]

# Notification configuration
notification_topic_prefix = "ovh-server-monitoring"
