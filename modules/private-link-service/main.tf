
data "azurerm_subnet" "this" {
  for_each             = var.private_link_services
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : var.resource_group_name
}

data "azurerm_lb" "this" {
  for_each            = var.private_link_services
  name                = each.value.loadbalancer_name
  resource_group_name = each.value.lb_resource_group != null ? each.value.lb_resource_group : var.resource_group_name
}

locals {
  frontend_ip_configurations = flatten([
    for lb in data.azurerm_lb.this : [
      for config in lb.frontend_ip_configuration : {
        name = config.name
        id   = config.id
      }
    ]
  ])
  frontend_ip_configurations_map = {
    for config in local.frontend_ip_configurations : config.name => config.id
  }
}

# - Private Link Service

resource "azurerm_private_link_service" "this" {
  for_each            = var.private_link_services
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value.pls_resource_group != null ? each.value.pls_resource_group : var.resource_group_name

  auto_approval_subscription_ids = lookup(each.value, "auto_approval_subscription_ids", null)
  visibility_subscription_ids    = lookup(each.value, "visibility_subscription_ids", null)
  load_balancer_frontend_ip_configuration_ids = tolist([coalesce(lookup(local.frontend_ip_configurations_map, each.value.frontend_ip_config_name))])
  enable_proxy_protocol                       = coalesce(each.value.enable_proxy_protocol, false)

  nat_ip_configuration {
    name                       = "${each.value["name"]}_primary_pls_nat"
    private_ip_address         = lookup(each.value, "private_ip_address", null)
    private_ip_address_version = coalesce(lookup(each.value, "private_ip_address_version"), "IPv4")
    subnet_id                  = lookup(data.azurerm_subnet.this, each.key)["id"]
    primary                    = true
  }

  tags = var.private_link_services_tags

}
