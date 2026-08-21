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
