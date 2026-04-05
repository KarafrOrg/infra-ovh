data "ovh_me" "account" {}

resource "ovh_dedicated_server" "server" {
  for_each                  = var.dedicated_servers
  ovh_subsidiary            = data.ovh_me.account.ovh_subsidiary
  service_name              = each.value.service_name
  display_name              = try(each.value.display_name, each.value.service_name)
  boot_id                   = try(each.value.boot_id, null)
  monitoring                = try(each.value.monitoring, true)
  state                     = try(each.value.state, "ok")
  prevent_install_on_create = false
  prevent_install_on_import = true
  plan {
    plan_code     = each.value.plan.plan_code
    pricing_mode  = try(each.value.plan.pricing_mode, "default")
    duration      = try(each.value.plan.duration, "P1M")
    configuration = { for config in each.value.configuration : config.label => config.value }
  }
  plan_option = [
    for option in each.value.plan_option : {
      plan_code    = option.plan_code
      duration     = try(option.duration, "P1M")
      pricing_mode = try(option.pricing_mode, "default")
      quantity     = try(option.quantity, 1)
    }
  ]
}
