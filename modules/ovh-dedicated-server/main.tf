data "ovh_me" "account" {}

resource "ovh_dedicated_server" "server" {
  for_each                  = var.dedicated_servers
  ovh_subsidiary            = data.ovh_me.account.ovh_subsidiary
  boot_id                   = try(each.value.boot_id, null)
  monitoring                = try(each.value.monitoring, true)
  state                     = try(each.value.state, "ok")
  range                     = try(each.value.commercial_range, "eco")
  os                        = local.operating_system
  properties                = {}
  prevent_install_on_import = false
  prevent_install_on_create = false
  plan = [
    {
      plan_code    = each.value.plan.plan_code
      pricing_mode = try(each.value.plan.pricing_mode, "default")
      duration     = try(each.value.plan.duration, "P1M")
      configuration = [
        for config in each.value.configuration : {
          label = config.label
          value = config.value
        }
      ]
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
  lifecycle {
    ignore_changes = [
      os,
      root_device,
      display_name
    ]
  }
}

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

resource "google_secret_manager_secret_version" "server_info" {
  for_each = var.dedicated_servers

  secret                = google_secret_manager_secret.server_info[each.key].id
  is_secret_data_base64 = false

  secret_data = jsonencode({
    service_name = ovh_dedicated_server.server[each.key].service_name
    monitoring   = ovh_dedicated_server.server[each.key].monitoring
    state        = ovh_dedicated_server.server[each.key].state
    labels       = try(each.value.labels, {})
  })
}

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
