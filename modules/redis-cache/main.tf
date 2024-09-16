module "avm-res-cache-redis" {
  source  = "Azure/avm-res-cache-redis/azurerm"
  version = "0.1.5"
  location = var.location
  name = var.name
  resource_group_name = var.resource_group_name
}