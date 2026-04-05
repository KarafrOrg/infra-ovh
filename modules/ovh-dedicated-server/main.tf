data "ovh_me" "account" {}

# Main OVH dedicated server resource
resource "ovh_dedicated_server" "server" {
  for_each = var.dedicated_servers

  service_name = each.value.service_name
  display_name = try(each.value.display_name, each.value.service_name)
  boot_id      = try(each.value.boot_id, null)
  monitoring   = try(each.value.monitoring, true)
  state        = try(each.value.state, "ok")

  # Prevent automatic OS installation when importing existing servers
  prevent_install_on_import = true
  plan = [
    {
      plan_code     = each.value.plan.plan_code
      pricing_mode  = try(each.value.plan.pricing_mode, "default")
      duration      = try(each.value.plan.duration, "P1M")
      configuration = { for config in each.value.configuration : config.label => config.value }
    }
  ]
  plan_option = [
    for option in each.value.plan_option : {
      plan_code    = option.plan_code
      pricing_mode = try(option.pricing_mode, "default")
      duration     = try(option.duration, "P1M")
      quantity     = try(option.quantity, 1)
    }
  ]
}


# GCP Secret Manager: Store server information
resource "google_secret_manager_secret" "server_info" {
  for_each = var.dedicated_servers

  secret_id = "${var.secret_prefix}-${each.key}-info"
  project   = var.gcp_project_name

  labels = merge(
    try(each.value.labels, {}),
    {
      managed_by = "terraform"
      server_key = each.key
    }
  )

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

# GCP Secret Manager: Store server information version with actual data
resource "google_secret_manager_secret_version" "server_info" {
  for_each = var.dedicated_servers

  secret = google_secret_manager_secret.server_info[each.key].id

  secret_data = jsonencode({
    service_name = each.value.service_name
    display_name = try(each.value.display_name, each.value.service_name)
    monitoring   = try(each.value.monitoring, true)
    state        = try(each.value.state, "ok")
    labels       = try(each.value.labels, {})
    last_updated = timestamp()
  })
}

# GCP Pub/Sub: Topics for server notifications
resource "google_pubsub_topic" "server_notifications" {
  for_each = { for k, v in var.dedicated_servers : k => v if try(v.enable_notifications, false) }

  name    = "${var.notification_topic_prefix}-${each.key}"
  project = var.gcp_project_name

  labels = merge(
    try(each.value.labels, {}),
    {
      managed_by = "terraform"
      server_key = each.key
    }
  )
}
