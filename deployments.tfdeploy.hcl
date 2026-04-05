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
    ovh_endpoint  = "ovh-eu"
    ovh_client_id = store.varset.credentials.ovh_client_id
    ovh_client_secret = store.varset.credentials.ovh_client_secret

    # Dedicated servers configuration
    dedicated_servers = {
      "server-1147291" = {
        service_name = "ns3156252.ip-135-125-223.eu"
        display_name = "ns3156252.ip-135-125-223.eu (SYS-1 | Intel Xeon-E 2136)"
        monitoring   = true
        state        = "ok"
        labels = {
          server_id = "1147291"
          region = "eu-west-lim"
          datacenter = "lim1"
          availability_zone = "eu-west-lim-a"
          model = "SYS-1-Intel_Xeon-E_2136"
          os = "ubuntu2510-server_64"
          ip = "135.125.223.211"
        }
      }
      "server-1147293" = {
        service_name = "ns3156292.ip-135-125-223.eu"
        display_name = "ns3156292.ip-135-125-223.eu (SYS-1 | Intel Xeon-E 2136)"
        monitoring   = true
        state        = "ok"
        labels = {
          server_id = "1147293"
          region = "eu-west-lim"
          datacenter = "lim1"
          availability_zone = "eu-west-lim-a"
          model = "SYS-1-Intel_Xeon-E_2136"
          os = "ubuntu2510-server_64"
          ip = "135.125.223.213"
        }
      }
      "server-1417389" = {
        service_name = "ns324588.ip-37-187-157.eu"
        display_name = "ns324588.ip-37-187-157.eu (KS-LE-2)"
        monitoring   = true
        state        = "ok"
        labels = {
          server_id = "1417389"
          region = "eu-west-gra"
          datacenter = "gra1"
          availability_zone = "eu-west-gra-a"
          model = "KS-LE-2"
          os = "ubuntu2510-server_64"
          ip = "37.187.157.64"
        }
      }
      "server-1859010" = {
        service_name = "ns331578.ip-37-187-159.eu"
        display_name = "ns331578.ip-37-187-159.eu (RISE-S | AMD Ryzen 7 9700X)"
        monitoring   = true
        state        = "ok"
        labels = {
          server_id = "1859010"
          region = "eu-west-gra"
          datacenter = "gra1"
          availability_zone = "eu-west-gra-a"
          model = "RISE-S-AMD_Ryzen_7_9700X"
          os = "ubuntu2510-server_64"
          ip = "37.187.159.125"
        }
      }
      "server-1432449" = {
        service_name = "ns338656.ip-5-196-78.eu"
        display_name = "ns338656.ip-5-196-78.eu (KS-LE-2)"
        monitoring   = true
        state        = "ok"
        labels = {
          server_id = "1432449"
          region = "eu-west-gra"
          datacenter = "gra1"
          availability_zone = "eu-west-gra-a"
          model = "KS-LE-2"
          os = "ubuntu2510-server_64"
          ip = "5.196.78.186"
        }
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

