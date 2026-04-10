terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "2.13.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.26.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "karafra-net"

    workspaces {
      name = "infra-ovh"
    }
  }
}

provider "google" {
  project = "karafra-net"
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}
