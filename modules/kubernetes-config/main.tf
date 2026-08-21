resource "kubernetes_service_account_v1" "automation_admin" {
  metadata {
    name      = "automation-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding_v1" "automation_admin" {
  metadata {
    name = "automation-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.automation_admin.metadata[0].name
    namespace = kubernetes_service_account_v1.automation_admin.metadata[0].namespace
  }
}

resource "kubernetes_secret_v1" "automation_admin_token" {
  metadata {
    name      = "automation-admin-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.automation_admin.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "google_secret_manager_secret" "automation_admin" {
  secret_id = var.automation_admin_secret_id

  labels = {
    managed_by = "terraform"
    role       = "automation-admin"
  }

  replication {
    dynamic "auto" {
      for_each = var.secret_replication_automatic ? [1] : []
      content {}
    }

    dynamic "user_managed" {
      for_each = var.secret_replication_automatic ? [] : [1]
      content {
        dynamic "replicas" {
          for_each = var.secret_replication_locations
          content {
            location = replicas.value
          }
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "automation_admin" {
  secret                = google_secret_manager_secret.automation_admin.id
  secret_data           = local.automation_admin_kubeconfig
  is_secret_data_base64 = false
  deletion_policy       = "ABANDON"
}

resource "kubernetes_cluster_role_binding_v1" "oidc_discovery_public" {
  metadata {
    name = "oidc-discovery-public"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:service-account-issuer-discovery"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:unauthenticated"
  }
}
