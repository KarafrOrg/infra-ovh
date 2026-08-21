
locals {
  automation_admin_kubeconfig = yamlencode({
    apiVersion = "v1"
    kind       = "Config"
    clusters = [{
      name = var.cluster_name
      cluster = {
        server                       = var.cluster_server
        "certificate-authority-data" = var.cluster_ca_cert
      }
    }]
    users = [{
      name = "automation-admin"
      user = {
        token = kubernetes_secret_v1.automation_admin_token.data.token
      }
    }]
    contexts = [{
      name = var.cluster_name
      context = {
        cluster = var.cluster_name
        user    = "automation-admin"
      }
    }]
    "current-context" = var.cluster_name
  })
}
