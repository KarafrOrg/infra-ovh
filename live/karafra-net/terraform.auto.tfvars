# OVH configuration
ovh_endpoint           = "ovh-ca"

# Dedicated servers configuration
dedicated_servers = {
  "k8s-node1" = {
    existing_server = true
    monitoring     = true
    state          = "ok"
    ssh_key_secret = "ovh-vps-ssh-public-key"
    labels = {
      os = "ubuntu2510-server_64"
    }
    plan = {
      pricing_mode = "default"
      duration     = "P1M"
      plan_code    = "26skle01-v1"
    },
    plan_option = [
      {
        pricing_mode = "default"
        duration     = "P1M"
        plan_code    = "softraid-3x2000sa-26skle01-v1"
        quantity     = 1,
      },
      {
        pricing_mode = "default"
        duration     = "P1M"
        plan_code    = "ram-32g-noecc-1333-26skle01-v1"
        quantity     = 1,
      },
      {
        pricing_mode = "default"
        duration     = "P1M"
        plan_code    = "bandwidth-1000-ks-gen0"
        quantity     = 1,
      },
    ]
    configuration = [
      {
        label = "METADATA_ESTIMATED_DELIVERY_TIME",
        value = "1H-high",
      },
      {
        label = "dedicated_datacenter",
        value = "bhs",
      },
      {
        label = "region",
        value = "canada",
      },
      {
        label = "dedicated_os",
        value = "none_64.en",
      },
    ]
  },
}

# Secret Manager configuration
secret_prefix                = "ovh-server"
secret_replication_automatic = true
secret_replication_locations = ["europe-west1", "europe-west3"]

# Notification configuration
notification_topic_prefix = "ovh-server-monitoring"
