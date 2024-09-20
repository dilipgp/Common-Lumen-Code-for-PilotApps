module "avm-res-resources-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"
  name = var.resource_group_name
  location = var.location
}
module "avm-res-network-virtualnetwork_example_default" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//examples/default"
  version = "0.4.0"
  location = var.location
  address_space = var.vnet_address_space
  resource_group_name = var.resource_group_name
}
module "avm-res-network-virtualnetwork_subnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.4.0"
  virtual_network = var.virtual_network
  name = var.resource_group_name
}

module "avm-res-network-networksecuritygroup_example_default" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm//examples/default"
  version = "0.2.0"
  resource_group_name = var.resource_group_name
  location = var.location
  name = var.nsg_name
}


module "avm-res-keyvault-vault_example_default" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.9.1"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.keyvault_name
  enable_telemetry    = var.enable_telemetry
  tenant_id           = var.tenant_id
}


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
}
 
module "avm-res-desktopvirtualization-applicationgroup" {
  source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
  version                                               = "0.1.5"
  virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool.resource.id
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


# module "avd" {
#   source = "./modules/avd"
#   # source             = "Azure/avm-ptn-avd-lza-managementplane/azurerm"
#   enable_telemetry                                   = var.enable_telemetry
#   location                                           = azurerm_resource_group.this.location
#   resource_group_name                                = azurerm_resource_group.this.name
#   virtual_desktop_workspace_name                     = var.virtual_desktop_workspace_name
#   virtual_desktop_scaling_plan_time_zone             = var.virtual_desktop_scaling_plan_time_zone
#   virtual_desktop_scaling_plan_name                  = var.virtual_desktop_scaling_plan_name
#   virtual_desktop_host_pool_type                     = var.virtual_desktop_host_pool_type
#   virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_name                     = var.virtual_desktop_host_pool_name
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
#   virtual_desktop_application_group_type             = var.virtual_desktop_application_group_type
#   virtual_desktop_application_group_name             = var.virtual_desktop_application_group_name
#   virtual_desktop_host_pool_friendly_name            = var.virtual_desktop_host_pool_friendly_name
#   log_analytics_workspace_name                       = module.naming.log_analytics_workspace.name_unique
# }