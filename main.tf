
## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
# module "regions" {
#   source  = "Azure/regions/azurerm"
#   version = ">= 0.3.0"
# }

# This allows us to randomize the region for the resource group.
# resource "random_integer" "region_index" {
#   max = length(module.regions.regions) - 1
#   min = 0
# }
## End of section to provide a random Azure region for the resource group

# # This ensures we have unique CAF compliant names for our resources.
# module "naming" {
#   source  = "Azure/naming/azurerm"
#   version = ">= 0.3.0"
# }

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
#   source              = "Azure/avm-res-keyvault-vault/azurerm"
#   version             = "0.9.1"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name
#   name                = var.keyvault_name
#   enable_telemetry    = var.enable_telemetry
#   tenant_id           = var.tenant_id
# }


module "avm-res-desktopvirtualization-hostpool" {
  source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
  version = "0.2.1"
  resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_host_pool_load_balancer_type = var.virtual_desktop_host_pool_load_balancer_type
  virtual_desktop_host_pool_location = var.location
  virtual_desktop_host_pool_name = var.virtual_desktop_host_pool_name
  virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_host_pool_type = var.virtual_desktop_host_pool_type
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
    setting1 = {
      name                                = "example-setting-1"
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "Dedicated"
      workspace_resource_id               = module.avm-res-operationalinsights-workspace.resource.id
      storage_account_resource_id         = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                      = null
      marketplace_partner_resource_id     = null
    },
  }
}

module "avm-res-desktopvirtualization-applicationgroup" {
  source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
  version                                               = "0.1.5"
  virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool.resource.id
  virtual_desktop_application_group_location            = var.location
  virtual_desktop_application_group_name                = var.virtual_desktop_application_group_name
  virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_application_group_type                = var.virtual_desktop_application_group_type
  diagnostic_settings = {
    setting1 = {
      name                                = "example-setting-1"
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "Dedicated"
      workspace_resource_id               = module.avm-res-operationalinsights-workspace.resource.id
      storage_account_resource_id         = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                      = null
      marketplace_partner_resource_id     = null
    },
  }
}



module "avm-res-desktopvirtualization-workspace" {
  source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
  version                                       = "0.1.5"
  resource_group_name                           = var.resource_group_name
  virtual_desktop_workspace_location            = var.location
  virtual_desktop_workspace_name                = var.virtual_desktop_workspace_name
  virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
  diagnostic_settings = {
    setting1 = {
      name                                = "example-setting-1"
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "Dedicated"
      workspace_resource_id               = module.avm-res-operationalinsights-workspace.resource.id
      storage_account_resource_id         = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                      = null
      marketplace_partner_resource_id     = null
    },
  }
}

module "avm-res-operationalinsights-workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.1"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.operationalinsights_workspace_name
  diagnostic_settings = {
    setting1 = {
      name                                = "example-setting-1"
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "Dedicated"
      workspace_resource_id               = module.avm-res-operationalinsights-workspace.resource.id
      storage_account_resource_id         = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                      = null
      marketplace_partner_resource_id     = null
    },
  }
}


module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.2.7"

  name                = "my-storage-account"
  location           = "eastus"
  resource_group_name = azurerm_resource_group.this.name
  shares = {
    share1 = {
      name = "share1"
      quota = 1024
    }
  }

  containers = {
    container1 = {
      name = "container1"
      public_access = "Container"
    }
  }
  
}