terraform {
  required_version = ">= 1.9"

  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "2.12.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.24"
    }
  }
}
