variable "node_ips" {
  description = "Public IPv4 addresses of all nodes. Nodes may only receive traffic from each other."
  type        = list(string)

  validation {
    condition     = length(var.node_ips) <= 18
    error_message = "OVH edge firewall allows 20 rules per IP; at most 18 node IPs are supported."
  }
}

variable "extra_allowed_cidrs" {
  description = "Additional source CIDRs allowed to reach every node (e.g. static runner IPs). Shares the 18-rule budget with node_ips."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.extra_allowed_cidrs) + length(var.node_ips) <= 18
    error_message = "OVH edge firewall allows 20 rules per IP; node_ips plus extra_allowed_cidrs must not exceed 18."
  }
}
