variable "gcp_project_name" {
  description = "GCP project name for Secret Manager"
  type        = string
}

variable "dedicated_servers" {
  description = "Map of dedicated server configurations"
  type = map(object({
    commercial_range = optional(string, "eco")
    boot_id          = optional(number)
    monitoring       = optional(bool, true)
    state            = optional(string, "ok")
    plan = object({
      pricing_mode = optional(string, "default")
      duration     = optional(string, "P1M")
      plan_code    = string
    })
    plan_option = list(object({
      duration     = optional(string, "P1M")
      plan_code    = string
      pricing_mode = optional(string, "default")
      quantity     = optional(number, 1)
    }))
    configuration = list(object({
      label = string
      value = string
    }))
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
