# # This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# # module "avm-res-keyvault-vault_example_default" {
# #   source              = "Azure/avm-res-keyvault-vault/azurerm"
# #   version             = "0.9.1"
# #   location            = var.location
# #   resource_group_name = azurerm_resource_group.this.name
# #   name                = var.keyvault_name
# #   enable_telemetry    = var.enable_telemetry
# #   tenant_id           = var.tenant_id
# # }


# module "avm-res-storage-storageaccount" {
#   source                                  = "Azure/avm-res-storage-storageaccount/azurerm"
#   version                                 = "0.2.7"
#   name                                    = "satestlumenmsft"
#   resource_group_name                     = azurerm_resource_group.this.name
#   location                                = var.location
#   # account_tier                            = var.account_tier
#   # account_replication_type                = var.account_replication_type
#   # account_kind                            = var.account_kind
#   # access_tier                             = var.access_tier
#   # tags                                    = local.tags
#   public_network_access_enabled           = true
#   # allow_nested_items_to_be_public         = var.sa_allow_nested_items_to_be_public
#   # infrastructure_encryption_enabled       = var.sa_infrastructure_encryption_enabled
#   shared_access_key_enabled               = true
#   # enable_telemetry                        = var.enable_telemetry
#   managed_identities = {
#     identity = {
#       system_assigned = true
#     }
#   }
#   private_endpoints = {
#       storagefilepe = {
#         name = "storageprivate"
#         subnet_resource_id = azurerm_subnet.example.id
#         subresource_name = "file"
#       },
#       storageblobpe = {
#         name = "storageprivate"
#         subnet_resource_id = azurerm_subnet.example.id
#         subresource_name = "blob"
#       }
#   }
# #   shares                                  = {
# #   share0 = {
# #     name        = "fileshare-1"
# #     quota       = 10
# #     access_tier = "Hot"
# #     metadata = {
# #       key1 = "value1"
# #       key2 = "value2"
# #     }
# #     signed_identifiers = [
# #       {
# #         id = "1"
# #         access_policy = {
# #           expiry_time = "2025-01-01T00:00:00Z"
# #           permission  = "r"
# #           start_time  = "2024-01-01T00:00:00Z"
# #         }
# #       }
# #     ]
# #   }
# # }
#   # tables                                  = var.tables
#   # queues                                  = var.queues
#   # containers                              = var.containers
#   # share_properties                        = var.share_properties
#   # large_file_share_enabled                = var.large_file_share_enabled
#   # azure_files_authentication              = var.azure_files_authentication
#   # immutability_policy                     = var.immutability_policy
#   # is_hns_enabled                          = var.is_hns_enabled
#   # blob_properties                         = var.blob_properties
#   # table_encryption_key_type               = var.table_encryption_key_type
#   # queue_encryption_key_type               = var.queue_encryption_key_type
#   # queue_properties                        = var.queue_properties
#   # private_endpoints                       = var.private_endpoints
#   # storage_management_policy_rule          = var.storage_management_policy_rule
#   # storage_management_policy_timeouts      = var.storage_management_policy_timeouts
#   # diagnostic_settings_storage_account     = var.diagnostic_settings_storage_account
#   # diagnostic_settings_blob                = var.diagnostic_settings_blob
#   # diagnostic_settings_queue               = var.diagnostic_settings_queue
#   # diagnostic_settings_table               = var.diagnostic_settings_table
#   # diagnostic_settings_file                = var.diagnostic_settings_file
#   # storage_data_lake_gen2_filesystem       = var.storage_data_lake_gen2_filesystem
#   # customer_managed_key                    = var.customer_managed_key
#   # lock                                    = var.lock
#   # managed_identities                      = var.managed_identities
#   # private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
#   # role_assignments                        = var.role_assignments
#   # allowed_copy_scope                      = var.allowed_copy_scope
#   # cross_tenant_replication_enabled        = var.cross_tenant_replication_enabled
#   # custom_domain                           = var.custom_domain
#   # default_to_oauth_authentication         = var.default_to_oauth_authentication
#   # edge_zone                               = var.edge_zone
#   # https_traffic_only_enabled              = var.https_traffic_only_enabled
#   # local_user                              = var.local_user
#   # min_tls_version                         = var.min_tls_version
#   # network_rules                           = var.network_rules
#   # nfsv3_enabled                           = var.nfsv3_enabled
#   # routing                                 = var.routing
#   # sas_policy                              = var.sas_policy
#   # sftp_enabled                            = var.sftp_enabled
#   # static_website                          = var.static_website
#   # timeouts                                = var.timeouts

# }

# resource "azurerm_storage_share" "example" {
#   name                 = "sharename"
#   storage_account_name = module.avm-res-storage-storageaccount.name
#   quota                = 50
#   acl {
#     id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
#     access_policy {
#       permissions = "rwdl"
#       start       = "2019-07-02T09:38:21.0000000Z"
#       expiry      = "2019-07-02T10:38:21.0000000Z"
#     }
#   }
# }
# module "avm-res-desktopvirtualization-hostpool" {
#   source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version = "0.2.1"
#   resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location = var.location
#   virtual_desktop_host_pool_name = var.virtual_desktop_host_pool_name
#   virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type = var.virtual_desktop_host_pool_type
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
#   virtual_desktop_host_pool_vm_template = {
#     type = "Gallery"
#     gallery_image_reference = {
#       publisher = "MicrosoftWindowsDesktop"
#       offer     = "Windows-11"
#       sku       = "win11-21h2-avd"
#       version   = "latest"
#     }
#     osDisktype = "PremiumLRS"
#   }
#   # diagnostic_settings = {
#   #   setting1 = {
#   #     name                                = "example-setting-2"
#   #     log_groups                          = ["allLogs"]
#   #     metric_categories                   = ["AllMetrics"]
#   #     log_analytics_destination_type      = "Dedicated"
#   #     workspace_resource_id               = module.avm-res-operationalinsights-workspace.resource.id
#   #     storage_account_resource_id         = null
#   #     event_hub_authorization_rule_resource_id = null
#   #     event_hub_name                      = null
#   #     marketplace_partner_resource_id     = null
#   #   },
#   # }
# }


# module "avm-res-desktopvirtualization-hostpool2" {
#   source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version = "0.2.1"
#   resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location = var.location
#   virtual_desktop_host_pool_name = "avdhostpool-2"
#   virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type = "Pooled"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
# }

# module "avm-res-desktopvirtualization-hostpool3" {
#   source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version = "0.2.1"
#   resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location = var.location
#   virtual_desktop_host_pool_name = "avdhostpool-3"
#   virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type = "Personal"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
# }

# module "avm-res-desktopvirtualization-hostpool4" {
#   source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version = "0.2.1"
#   resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location = var.location
#   virtual_desktop_host_pool_name = "avdhostpool-4"
#   virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type = "Personal"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
# }

# module "avm-res-desktopvirtualization-applicationgroup1" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "applicationgroup-1"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "RemoteApp"
# }

# module "avm-res-desktopvirtualization-applicationgroup2" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "desktopgroup-1"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "Desktop"
# }

# module "avm-res-desktopvirtualization-applicationgroup3" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool2.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "applicationgroup-2"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "RemoteApp"
# }

# module "avm-res-desktopvirtualization-applicationgroup4" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool2.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "desktopgroup-2"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "Desktop"
# }

# module "avm-res-desktopvirtualization-applicationgroup6" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool3.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "desktopgroup-3"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "Desktop"
# }

# module "avm-res-desktopvirtualization-applicationgroup8" {
#   source                                                = "Azure/avm-res-desktopvirtualization-applicationgroup/azurerm"
#   version                                               = "0.1.5"
#   virtual_desktop_application_group_host_pool_id        = module.avm-res-desktopvirtualization-hostpool4.resource.id
#   virtual_desktop_application_group_location            = var.location
#   virtual_desktop_application_group_name                = "desktopgroup-4"
#   virtual_desktop_application_group_resource_group_name = azurerm_resource_group.this.name
#   virtual_desktop_application_group_type                = "Desktop"
# }



# module "avm-res-desktopvirtualization-workspace" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = var.virtual_desktop_workspace_name
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
# }

# module "avm-res-desktopvirtualization-workspace2" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace2"
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
# }

# module "avm-res-desktopvirtualization-workspace3" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace3"
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
# }

# module "avm-res-desktopvirtualization-workspace4" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace4"
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
# }

# module "avm-res-operationalinsights-workspace" {
#   source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
#   version = "0.4.1"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name
#   name                = var.operationalinsights_workspace_name
# }


# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.this.location
#   resource_group_name = azurerm_resource_group.this.name
# }

# resource "azurerm_subnet" "example" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.this.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# module "avm-res-compute-virtualmachine" {
#   source  = "Azure/avm-res-compute-virtualmachine/azurerm"
#   version = "0.16.0"

#   # Required variables
#   network_interfaces = {
#     example_nic = {
#       name = "example-nic"
#       ip_configurations = {
#         ipconfig1 = {
#           name     = "internal"
#           private_ip_subnet_resource_id = azurerm_subnet.example.id
#         }
#       }
#     }
#   }

#   zone = 1
#   name = "example-vm"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   admin_username      = "adminuser"
#   admin_password      = "Password1234!"


#   # Image configuration
#   source_image_reference = {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "Windows-11"
#     sku       = "win11-21h2-avd"
#     version   = "latest"
#   }
#   # Optional variables (add as needed)

#   os_disk = {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   tags = {
#     environment = "production"
#   }
# }

# resource "azurerm_virtual_machine_extension" "vmext_dsc" {
#   count                      = 1
#   name                       = "avd_dsc"
#   virtual_machine_id         = module.avm-res-compute-virtualmachine.resource.id
#   publisher                  = "Microsoft.Powershell"
#   type                       = "DSC"
#   type_handler_version       = "2.73"
#   auto_upgrade_minor_version = true

#   settings = <<-SETTINGS
#     {
#       "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
#       "configurationFunction": "Configuration.ps1\\AddSessionHost",
#       "properties": {
#         "HostPoolName":"${var.virtual_desktop_host_pool_name}"
#       }
#     }
#   SETTINGS

#   protected_settings = <<PROTECTED_SETTINGS
#   {
#     "properties": {
#       "registrationInfoToken": "${module.avm-res-desktopvirtualization-hostpool.registrationinfo_token}"
#     }
#   }
#   PROTECTED_SETTINGS


#   depends_on = [
#     module.avm-res-compute-virtualmachine,
#     module.avm-res-desktopvirtualization-hostpool
#   ]
# }

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "avm-res-compute-virtualmachine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.16.0"

  # Required variables
  network_interfaces = {
    example_nic = {
      name = "example-nic1"
      ip_configurations = {
        ipconfig1 = {
          name     = "internal"
          private_ip_subnet_resource_id = azurerm_subnet.example.id
        }
      }
    }
  }

  zone = 1
  name = "example-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  sku_size = "Standard_D8ls_v5"
  # Image configuration
  source_image_reference = { 
    "offer": "WindowsServer", 
    "publisher": "MicrosoftWindowsServer", 
    "sku": "2022-datacenter-g2", 
    "version": "latest" 
  }
  # Optional variables (add as needed)

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_bastion_host" "example" {
  name                = "example-bastion"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_name            = "example-bastion-dns"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.example.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}