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
    dedicated_servers = {}

    # Secret Manager configuration
    secret_prefix                = "ovh-server"
    secret_replication_automatic = true
    secret_replication_locations = ["europe-west1", "europe-west3"]

    # Notification configuration
    notification_topic_prefix = "ovh-server-monitoring"
  }
}

