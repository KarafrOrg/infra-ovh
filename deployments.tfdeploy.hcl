store "varset" "credentials" {
  name     = "infra-ovh-variables"
  category = "terraform"
}

identity_token "gcp" {
  audience = [
    "//iam.googleapis.com/projects/1019265211616/locations/global/workloadIdentityPools/terraform-cloud/providers/terraform-cloud"
  ]
}

deployment "ovh-production" {
  inputs = {
    # GCP configuration
    gcp_identity_token        = identity_token.gcp.jwt
    gcp_zone                  = "europe-central2-a"
    gcp_audience              = "//iam.googleapis.com/projects/1019265211616/locations/global/workloadIdentityPools/terraform-cloud/providers/terraform-cloud"
    gcp_service_account_email = store.varset.credentials.gcp_service_account_email
    gcp_project_name          = "karafra-net"
    gcp_region = "europe-central2"

    # OVH configuration
    ovh_endpoint           = "ovh-ca"
    ovh_application_key    = store.varset.credentials.ovh_application_key
    ovh_application_secret = store.varset.credentials.ovh_application_secret
    ovh_consumer_key = store.varset.credentials.ovh_consumer_key

    # Dedicated servers configuration
    dedicated_servers = {
      "k8s-node1" = {
        service_name = "ns338656.ip-5-196-78.eu"
        display_name = "k8s node-1"
        monitoring   = true
        state        = "ok"
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
      }
    }

    # Secret Manager configuration
    secret_prefix                = "ovh-server"
    secret_replication_automatic = true
    secret_replication_locations = ["europe-west1", "europe-west3"]

    # Notification configuration
    notification_topic_prefix = "ovh-server-monitoring"
  }
}

