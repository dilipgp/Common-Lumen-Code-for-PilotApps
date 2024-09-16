#---------------------------------------------------------------
# Private Endpoint Creation
#---------------------------------------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoints
  name                = each.value.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = "/subscriptions/${var.subscription_id}/resourceGroups/${var.virtual_network_rg}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}/subnets/${var.pe_subnet_name}"

  private_service_connection {
    name                           = "${each.value.name}-psc"
    private_connection_resource_id = each.value.private_connection_resource_id
    is_manual_connection           = lookup(each.value, "is_manual_connection", false)
    subresource_names              = each.value.subresource_names
    request_message                = lookup(each.value, "request_message", null)
  }

  private_dns_zone_group {
    name                 = each.value.private_dns_zone_group_name
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}