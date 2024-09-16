module "avm-res-compute-virtualmachine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.1"
  # insert the 5 required variables here
  name = var.name
  location = var.location
  network_interfaces = var.network_interfaces
  zone = var.zone
  resource_group_name = var.resource_group_name
}