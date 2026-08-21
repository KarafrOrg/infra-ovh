locals {
  all_ips          = concat(var.control_plane_ips, var.worker_ips)
  cluster_endpoint = coalesce(var.cluster_endpoint, var.control_plane_ips[0])

  # Parsed after bootstrap to expose CA cert and server URL for downstream use.
  kubeconfig_parsed = yamldecode(talos_cluster_kubeconfig.this.kubeconfig_raw)
  cluster_ca_cert   = local.kubeconfig_parsed.clusters[0].cluster["certificate-authority-data"]
  cluster_server    = local.kubeconfig_parsed.clusters[0].cluster.server
}
