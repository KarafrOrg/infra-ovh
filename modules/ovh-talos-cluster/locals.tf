locals {
  all_ips          = concat(var.control_plane_ips, var.worker_ips)
  cluster_endpoint = coalesce(var.cluster_endpoint, var.control_plane_ips[0])
}
