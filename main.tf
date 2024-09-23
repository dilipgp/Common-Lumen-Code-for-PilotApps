

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


module "avm-res-desktopvirtualization-hostpool" {
  source                                        = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
  version                                       = "0.2.1"
  resource_group_name                           = var.resource_group_name
  virtual_desktop_host_pool_load_balancer_type  = var.virtual_desktop_host_pool_load_balancer_type
  virtual_desktop_host_pool_location            = var.location
  virtual_desktop_host_pool_name                = var.virtual_desktop_host_pool_name
  virtual_desktop_host_pool_resource_group_name = var.resource_group_name
  virtual_desktop_host_pool_type                = var.virtual_desktop_host_pool_type
  virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
  virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
  virtual_desktop_host_pool_vm_template = {
    type = "Gallery"
    gallery_image_reference = {
      offer     = "office-365"
      publisher = "microsoftwindowsdesktop"
      sku       = "22h2-evd-o365pp"
      version   = "latest"
    }
    osDisktype = "PremiumLRS"
  }
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }
  virtual_desktop_host_pool_scheduled_agent_updates = {
    enabled = "true"
    schedule = tolist([{
      day_of_week = "Sunday"
      hour_of_day = 0
    }])
  }
}

module "avm-res-desktopvirtualization-applicationgroup" {
  source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
  version                                               = "0.1.5"
  virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool_example_private-endpoint.resource_id
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