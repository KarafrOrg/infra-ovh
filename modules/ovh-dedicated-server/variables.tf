variable "dedicated_servers" {
  description = "Map of dedicated server configurations"
  type = map(object({
    existing_server  = optional(bool, false)
    commercial_range = optional(string, "eco")
    boot_id          = optional(number)
    monitoring       = optional(bool, true)
    state            = optional(string, "ok")
    service_name     = optional(string)
    ssh_key_secret   = optional(string)
    reinstall        = optional(bool, false)
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
}

variable "ssh_keys" {
  description = "Map of SSH keys to store in Secret Manager"
  type = map(object({
    public_key = string
    labels     = optional(map(string), {})
  }))
  sensitive = true
}

variable "secret_prefix" {
  description = "Prefix for secret names in GCP Secret Manager"
  type        = string
}

variable "secret_replication_automatic" {
  description = "Whether to use automatic replication for secrets (true) or user-managed replication (false)"
  type        = bool
}

variable "secret_replication_locations" {
  description = "List of GCP regions for secret replication when using user-managed replication"
  type        = list(string)
}

variable "notification_topic_prefix" {
  description = "Prefix for Pub/Sub topic names for server notifications"
  type        = string
}
