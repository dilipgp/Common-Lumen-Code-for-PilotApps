module "avm-res-network-bastionhost" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"
  location = var.location
  name = var.name
  resource_group_name = var.resource_group_name
  ip_configuration = var.ip_configuration
}