module "avm-res-databricks-workspace" {
  source  = "Azure/avm-res-databricks-workspace/azurerm"
  version = "0.2.0"
  # insert the 4 required variables here
  resource_group_name = var.resource_group_name
  sku = var.sku
  location = var.location
  name = var.name
}