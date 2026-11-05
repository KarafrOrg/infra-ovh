locals {
  node_ips = toset(var.node_ips)

  sorted_ips = sort(var.node_ips)

  sources = concat(
    [for ip in local.sorted_ips : "${ip}/32"],
    sort(var.extra_allowed_cidrs),
  )

  peer_rules = {
    for pair in setproduct(local.sorted_ips, local.sources) :
    "${pair[0]}|${pair[1]}" => {
      target   = pair[0]
      source   = pair[1]
      sequence = index(local.sources, pair[1]) + 1
    }
  }
}

resource "ovh_ip_firewall" "node" {
  for_each = local.node_ips

  ip             = "${each.value}/32"
  ip_on_firewall = each.value
  enabled        = true
}

resource "ovh_ip_firewall_rule" "allow_established" {
  for_each = local.node_ips

  ip             = ovh_ip_firewall.node[each.key].ip
  ip_on_firewall = ovh_ip_firewall.node[each.key].ip_on_firewall
  sequence       = 0
  action         = "permit"
  protocol       = "tcp"
  tcp_option     = "established"
}

resource "ovh_ip_firewall_rule" "allow_peer" {
  for_each = local.peer_rules

  ip             = ovh_ip_firewall.node[each.value.target].ip
  ip_on_firewall = ovh_ip_firewall.node[each.value.target].ip_on_firewall
  sequence       = each.value.sequence
  action         = "permit"
  protocol       = "ipv4"
  source         = each.value.source

  depends_on = [ovh_ip_firewall_rule.allow_established]
}

resource "ovh_ip_firewall_rule" "deny_all" {
  for_each = local.node_ips

  ip             = ovh_ip_firewall.node[each.key].ip
  ip_on_firewall = ovh_ip_firewall.node[each.key].ip_on_firewall
  sequence       = 19
  action         = "deny"
  protocol       = "ipv4"

  depends_on = [ovh_ip_firewall_rule.allow_peer]
}
