module "avm-res-network-routetable" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "0.2.2"
  location = var.location
  resource_group_name = var.resource_group_name
  name = var.name
}