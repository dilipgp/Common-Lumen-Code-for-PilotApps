module "avm-res-containerregistry-registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.2.0"
  # insert the 3 required variables here
  name = var.name
  resource_group_name = var.resource_group_name
  location = var.location
}