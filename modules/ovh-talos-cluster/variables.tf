variable "control_plane_ips" {
  description = "List of IP addresses for Talos control plane nodes"
  type        = list(string)
}

variable "worker_ips" {
  description = "List of IP addresses for Talos worker nodes"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes API server endpoint IP or hostname. Defaults to the first control plane IP."
  type        = string
  default     = null
}

variable "kubeconfig_secret_id" {
  description = "GCP Secret Manager secret ID for storing the cluster kubeconfig"
  type        = string
  default     = null
}

variable "secret_replication_automatic" {
  description = "Whether to use automatic replication for the kubeconfig secret"
  type        = bool
  default     = true
}

variable "secret_replication_locations" {
  description = "GCP regions for kubeconfig secret replication when not using automatic"
  type        = list(string)
  default     = ["europe-west1", "europe-west3"]
}
