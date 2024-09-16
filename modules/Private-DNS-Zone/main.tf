module "avm-res-network-privatednszone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.1.2"
  # insert the 2 required variables here
  domain_name = var.domain_name
  resource_group_name = var.resource_group_name
}