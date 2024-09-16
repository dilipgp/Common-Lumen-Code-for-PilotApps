module "resourceGroup" {
  source  = "./modules/resourceGroup"
  name = var.rg_name
  location = var.rg_location
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}


resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

# resource "random_integer" "region_index" {
#   max = length(local.test_regions) - 1
#   min = 0
# }

# module "LogAnalyticsWorkspace" {
#     source = "./modules/log-analytics-workspace"
#     name = var.law_name
#     location= var.law_location
#     resource_group_name = var.law_resource_group_name
#     sku = var.law_sku
#     retention_in_days = var.law_retention_in_days
#     depends_on = [ module.resourceGroup ]
# }








# resource "random_id" "id" {
#   byte_length = 4
# }

# resource "azurerm_user_assigned_identity" "management" {
#   location            = var.rg_location
#   name                = "id-terraform-${random_id.id.hex}"
#   resource_group_name = var.rg_name

#   depends_on = [
#     module.resourceGroup
#   ]
# }

# module "automationaccount" {
#   source = "./modules/automation-account"

#   automation_account_name      = var.aa_name
#   location                     = var.rg_location
#   resource_group_name          = var.rg_name


#   automation_account_identity = {
#     type         = "SystemAssigned, UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.management.id]
#   }

#   automation_account_local_authentication_enabled  = true
#   automation_account_public_network_access_enabled = true
#   automation_account_sku_name                      = "Basic"
#   linked_automation_account_creation_enabled       = true


#   log_analytics_workspace_allow_resource_only_permissions    = true
#   log_analytics_workspace_cmk_for_query_forced               = true
#   log_analytics_workspace_daily_quota_gb                     = 1
#   log_analytics_workspace_internet_ingestion_enabled         = true
#   log_analytics_workspace_internet_query_enabled             = true
#   log_analytics_workspace_reservation_capacity_in_gb_per_day = 200
#   log_analytics_workspace_retention_in_days                  = 50
#   log_analytics_workspace_sku                                = "CapacityReservation"
#   resource_group_creation_enabled                            = false

#   tags = {
#     environment = "dev"
#   }
#   depends_on = [
#     azurerm_user_assigned_identity.management,
#   ]
# }


# module "lawsolution" {
#   source = "./modules/loganalytics-solutions"

#   location                     = var.rg_location
#   resource_group_name          = var.rg_name
#   log_analytics_workspace_name = module.LogAnalyticsWorkspace.log_analytics_workspace["name"]

#   read_access_id               = module.automationaccount.aut_act_id
#   workspace_id                 = module.LogAnalyticsWorkspace.log_analytics_workspace["id"]

#   linked_automation_account_creation_enabled       = true

#   log_analytics_solution_plans = [
#     {
#       product   = "OMSGallery/AgentHealthAssessment"
#       publisher = "Microsoft"
#     },
#     {
#       product   = "OMSGallery/AntiMalware"
#       publisher = "Microsoft"
#     },
#     {
#       product   = "OMSGallery/ChangeTracking"
#       publisher = "Microsoft"
#     },
#     {
#       product   = "OMSGallery/ContainerInsights"
#       publisher = "Microsoft"
#     },
#     {
#       product   = "OMSGallery/Security"
#       publisher = "Microsoft"
#     },
#     {
#       product   = "OMSGallery/SecurityInsights"
#       publisher = "Microsoft"
#     }
#   ]

#   tags = {
#     environment = "dev"
#   }
# }

# module "naming" {
#   source  = "Azure/naming/azurerm"
#   version = "0.3.0"
# }

data "azurerm_client_config" "this" {}

# module "keyvault" {
#   source = "./modules/key-vault"
#   # source              = "Azure/avm-res-keyvault-vault/azurerm"
#   name                = var.kv_name
#   enable_telemetry    = var.enable_telemetry
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   tenant_id           = data.azurerm_client_config.this.tenant_id
# }


# module "vnet" {
#   source              = "./modules/vnet"
#   name                = var.vnet_name
#   enable_telemetry    = true
#   resource_group_name = var.rg_name
#   location            = var.rg_location

#   address_space = ["10.0.0.0/16"]
# }

## WORKING STORAGE ACCOUNT START ##

# module "avm-res-storage-storageaccount" {
#   source  = "Azure/avm-res-storage-storageaccount/azurerm"
#   version = "0.2.3"
#   resource_group_name = var.rg_name
#   location = var.rg_location
#   name = var.strg_acct_name
#   shared_access_key_enabled = false
#   depends_on = [ module.resourceGroup ]
# }

## WORKING STORAGE ACCOUNT ENDS ##


## WORKING wEBAPP START ##

# resource "azurerm_service_plan" "this" {
#   location            = var.rg_location
#   name                = module.naming.app_service_plan.name_unique
#   os_type             = "Linux"
#   resource_group_name = var.rg_name
#   sku_name            = "S1"
#   depends_on = [ module.resourceGroup ]
# }

# module "avm-res-web-site" {
#   source  = "Azure/avm-res-web-site/azurerm"
#   version = "0.9.1"
#   resource_group_name = var.rg_name
#   location = var.rg_location
#   name = var.strg_acct_name
#   kind = var.kind
#   os_type = var.os_type
#   create_service_plan = false
#   service_plan_resource_id = azurerm_service_plan.this.id
#   depends_on = [ module.resourceGroup ]
# }

## WORKING STORAGE ACCOUNT ENDS ##


# module "keyvault" {
#   source = "./modules/key-vault"
#   # source              = "Azure/avm-res-keyvault-vault/azurerm"
#   name                = var.kv_name
#   enable_telemetry    = var.enable_telemetry
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   tenant_id           = data.azurerm_client_config.this.tenant_id
#   depends_on = [ module.resourceGroup ]
# }

# module "recovery_vault" {
#   source = "./modules/recovery-service-vault"
#   # source              = "Azure/avm-res-keyvault-vault/azurerm"
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   recovery_services_vault_name = module.naming.recovery_services_vault.name
#   enable_encryption = false
#   depends_on = [ module.resourceGroup ]
# }


# module "avm-ptn-aks-production" {
#   source  = "Azure/avm-ptn-aks-production/azurerm"
#   version = "0.1.0"
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   name                = var.aks_name
#   kubernetes_version  = "1.29" 
#   # node_pools = {
#   #   name    = "agentpool"
#   #   vm_size = "Standard_D2s_v4"
#   # }
#   depends_on = [ module.resourceGroup ]
# }




# resource "azurerm_user_assigned_identity" "this" {
#   location            = var.rg_location
#   name                = "uami-${var.aks_name}"
#   resource_group_name = var.rg_name
#   depends_on = [ module.resourceGroup ]
# }

# # This is the module call
# # Do not specify location here due to the randomization above.
# # Leaving location as `null` will cause the module to use the resource group location
# # with a data source.
# module "avm-ptn-aks-production" {
#   source              = "Azure/avm-ptn-aks-production/azurerm"
#   depends_on = [ module.resourceGroup ]
#   kubernetes_version  = "1.29"
#   enable_telemetry    = var.enable_telemetry # see variables.tf
#   name                = var.aks_name
#   resource_group_name = var.rg_name
#   managed_identities = {
#     user_assigned_resource_ids = [
#       azurerm_user_assigned_identity.this.id
#     ]
#   }

#   location = var.rg_location # Hardcoded because we have to test in a region with availability zones
#   node_pools = {
#     workload = {
#       name                 = "workload"
#       vm_size              = "Standard_D2s_v4"
#       orchestrator_version = "1.29"
#       max_count            = 110
#       min_count            = 2
#       os_sku               = "Ubuntu"
#       mode                 = "User"
#     }
#   }
# }


module "avm-ptn-aks-production" {
  source              = "Azure/avm-ptn-aks-production/azurerm" #"./modules/azure-kubernetes-service"
  version = "0.1.0"
  # kubernetes_version  = "1.29"
  # enable_telemetry    = var.enable_telemetry # see variables.tf
  name                = var.aks_name
  resource_group_name = var.rg_name
  location            = var.rg_location # Hardcoded instead of using module.regions because The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, and so Terraform cannot determine the full set of keys that will identify the instances of this resource.
  # pod_cidr            = "192.168.0.0/16"
  # node_cidr           = "10.31.0.0/16"
  depends_on = [ module.resourceGroup ]
}