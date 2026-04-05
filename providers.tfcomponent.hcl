required_providers {
  ovh = {
    source  = "ovh/ovh"
    version = "~> 2.12"
  }
  google = {
    source  = "hashicorp/google"
    version = "~> 7.24"
  }
}

provider "google" "main" {
  config {
    project = var.gcp_project_name
    region  = var.gcp_region
    zone    = var.gcp_zone
    external_credentials {
      audience              = var.gcp_audience
      service_account_email = var.gcp_service_account_email
      identity_token        = var.gcp_identity_token
    }
  }
}

provider "ovh" "main" {
  config {
    endpoint     = var.ovh_endpoint
    application_key    = var.ovh_application_key
    application_secret = var.ovh_application_secret
    consumer_key       = var.ovh_consumer_key
  }
}
