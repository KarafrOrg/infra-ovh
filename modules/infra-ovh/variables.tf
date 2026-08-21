variable "kubeconfig_secret_id" {
  description = "GCP Secret Manager secret ID for storing the cluster kubeconfig"
  type        = string
  default     = "talos-kubeconfig"
}

variable "talosconfig_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Talos client configuration"
  type        = string
  default     = "talos-client-config"
}

variable "k8s_api_endpoint_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Kubernetes API endpoint"
  type        = string
  default     = "k8s-api-endpoint"
}

variable "k8s_api_certificate_authority_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Kubernetes API certificate authority"
  type        = string
  default     = "k8s-api-certificate-authority"
}

variable "k8s_api_client_certificate_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Kubernetes API client certificate"
  type        = string
  default     = "k8s-api-client-certificate"
}

variable "k8s_api_token_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Kubernetes API token"
  type        = string
  default     = "k8s-api-token"
}

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "karafra-net"
}

variable "cluster_endpoint" {
  description = "Kubernetes API server endpoint. Defaults to the first control plane IP from server labels."
  type        = string
  default     = null
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

variable "cloudflare_tunnel_token_secret_id" {
  description = "GCP Secret Manager secret ID for storing the Cloudflare tunnel token"
  type        = string
}

variable "oidc_issuer_host" {
  description = "OIDC issuer host for the Kubernetes API server"
  type        = string
}
