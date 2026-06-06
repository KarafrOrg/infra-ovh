variable "ovh_credentials_secret_names" {
  description = "Names of GCP secrets containing OVH API credentials"
  type = object({
    application_key    = string
    application_secret = string
    consumer_key       = string
  })
  default = {
    application_key    = "ovh-application-key"
    application_secret = "ovh-application-secret"
    consumer_key       = "ovh-consumer-key"
  }
}

# Server Configuration Variables
variable "dedicated_servers" {
  description = "Map of OVH dedicated server configurations"
  type = map(object({
    boot_id          = optional(number)
    monitoring       = optional(bool, true)
    state            = optional(string, "ok")
    commercial_range = optional(string, "eco")
    install_template = optional(string)
    service_name     = optional(string)
    reinstall        = optional(bool, false)
    ssh_key_secret   = optional(string)
    plan = optional(object({
      pricing_mode = optional(string, "default")
      duration     = optional(string, "P1M")
      plan_code    = string
    }))
    plan_option = optional(list(object({
      duration     = optional(string, "P1M")
      plan_code    = string
      pricing_mode = optional(string, "default")
      quantity     = optional(number, 1)
    })), [])
    configuration = optional(list(object({
      label = string
      value = string
    })), [])
    enable_notifications = optional(bool, false)
    labels               = optional(map(string), {})
  }))
  default = {}
}

variable "ssh_keys" {
  description = "Map of SSH keys to store in Secret Manager"
  type = map(object({
    public_key = string
    labels     = optional(map(string), {})
  }))
  default   = {}
  sensitive = true
}

variable "secret_prefix" {
  description = "Prefix for secret names in GCP Secret Manager"
  type        = string
  default     = "ovh-server"
}

variable "secret_replication_automatic" {
  description = "Whether to use automatic replication for secrets (true) or user-managed replication (false)"
  type        = bool
  default     = true
}

variable "secret_replication_locations" {
  description = "List of GCP regions for secret replication when using user-managed replication"
  type        = list(string)
  default     = ["europe-west1", "europe-west3"]
}

variable "notification_topic_prefix" {
  description = "Prefix for Pub/Sub topic names for server notifications"
  type        = string
  default     = "ovh-server-monitoring"
}

variable "ovh_endpoint" {
  description = "OVH API endpoint"
  type        = string
}

variable "ovh_application_key" {
  description = "OVH API application key"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "ovh_application_secret" {
  description = "OVH API application secret"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "ovh_consumer_key" {
  description = "OVH API consumer key"
  type        = string
  sensitive   = true
  ephemeral   = true
}
