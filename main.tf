

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# module "avm-res-keyvault-vault_example_default" {
#   source  = "Azure/avm-res-keyvault-vault/azurerm"
#   version = "0.9.1"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name
#   name                = var.keyvault_name
#   enable_telemetry    = var.enable_telemetry
#   tenant_id           = var.tenant_id
#   contacts            = var.contacts
# }

module "avm-res-keyvault-vault_example_default" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.9.1"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.keyvault_name
  enable_telemetry    = var.enable_telemetry
  tenant_id           = var.tenant_id
}

# module "avm-res-keyvault-vault_secret" {
#   source  = "Azure/avm-res-keyvault-vault/azurerm//modules/secret"
#   version = "0.9.1"
#   key_vault_resource_id = module.avm-res-keyvault-vault_example_default.resource_id
#   name   = "mySecret"
#   value  = "mySecretValue"
# }

module "avm-res-storage-storageaccount" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  name                = var.storage_accont_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "0.2.6"
}

module "hpavd" {
  source = "./modules/avd-hp-pe"
  enable_telemetry = var.enable_telemetry
  location = var.location
  resource_group_name = var.resource_group_name
}


module "avm-res-desktopvirtualization-applicationgroup" {
  source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
  version                                               = "0.1.5"
  virtual_desktop_application_group_host_pool_id        = module.hpavd.hostpool_id
  virtual_desktop_application_group_location            = var.location
  virtual_desktop_application_group_name                = var.virtual_desktop_application_group_name
  virtual_desktop_application_group_resource_group_name = var.resource_group_name
  virtual_desktop_application_group_type                = var.virtual_desktop_application_group_type
}
module "avm-res-desktopvirtualization-workspace" {
  source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
  version                                       = "0.1.5"
  resource_group_name                           = var.resource_group_name
  virtual_desktop_workspace_location            = var.location
  virtual_desktop_workspace_name                = var.virtual_desktop_workspace_name
  virtual_desktop_workspace_resource_group_name = var.resource_group_name
}