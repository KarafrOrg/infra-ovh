variable "cluster_name" {
  description = "Name of the cluster (used in kubeconfig context)"
  type        = string
}

variable "cluster_server" {
  description = "Kubernetes API server URL"
  type        = string
}

variable "cluster_ca_cert" {
  description = "Base64-encoded cluster CA certificate"
  type        = string
  sensitive   = true
}

variable "automation_admin_secret_id" {
  description = "GCP Secret Manager secret ID for the automation-admin kubeconfig"
  type        = string
  default     = "talos-automation-admin-kubeconfig"
}

variable "secret_replication_automatic" {
  description = "Whether to use automatic replication for secrets"
  type        = bool
  default     = true
}

variable "secret_replication_locations" {
  description = "GCP regions for secret replication when not using automatic"
  type        = list(string)
  default     = ["europe-west1", "europe-west3"]
}
