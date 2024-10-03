#This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}


module "avm-res-network-privatednszone" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "0.1.2"
  domain_name         = var.domain_name
  resource_group_name = azurerm_resource_group.this.name
# resource "azurerm_network_interface" "winvm_nic" {
#   for_each            = var.winvm  # Loop over the same winvm map
#   name                = "${each.value.name}-nic"
#   location            = var.location
#   resource_group_name = var.resource_group_name

  #Associate the NIC with the subnet in your virtual network
#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.example.id  # Ensure the subnet resource exists
#     private_ip_address_allocation = "Dynamic"
#   }
# }
}
data "azurerm_client_config" "this" {}

module "avm-res-keyvault-vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.9.1"
  #insert the 4 required variables here
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  name                = var.keyvault_name
  enable_telemetry    = var.enable_telemetry
  tenant_id           = var.tenant
  public_network_access_enabled = true
 # legacy_access_policies_enabled = true
#  legacy_access_policies = {
#     test = {
#       object_id               = data.azurerm_client_config.this.object_id
#       secret_permissions      = ["Get","List","Set"]
      

#     }
#}

  network_acls = {
    default_action             = "Allow"
  }
  
  private_endpoints = {
    primary = {
      kv_domain        = var.kv_domain
      subnet_resource_id = azurerm_subnet.example.id
      object_id          = var.object_id
      tenant_id          = var.tenant
    }
  }
}
resource "azurerm_key_vault_access_policy" "deploy" {
  key_vault_id = module.avm-res-keyvault-vault.resource_id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = data.azurerm_client_config.this.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
  # certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover"]
  # storage_permissions     = ["Get", "List", "Update", "Delete"]
}

resource "random_string" "secret_value" {
  length  = 16
  special = true
}


resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = random_string.secret_value.result
  key_vault_id = module.avm-res-keyvault-vault.resource_id
}

output "secret_value" {
  value = azurerm_key_vault_secret.example.id
  sensitive = true
}

module "avm-res-storage-storageaccount" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  version             = "0.2.7"
  name                = "satestlumenmsft"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  public_network_access_enabled = true
  allow_nested_items_to_be_public         = true
 # infrastructure_encryption_enabled       = var.sa_infrastructure_encryption_enabled
  shared_access_key_enabled = true
  managed_identities = {
    identity = {
      system_assigned = true
    }
  }
  network_rules = {
    default_action             = "Allow"
  }
  private_endpoints = {
        storagepe = {
          name = "storageprivate"
          subnet_resource_id = azurerm_subnet.example.id
          subresource_name = "file"
          resource_group_name = var.resource_group_name
        }
    }
    
 }
 

resource "azurerm_storage_share" "example" {
  name                 = "sharename"
  storage_account_name = module.avm-res-storage-storageaccount.name
  quota                = 50
  acl {
    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}
# module "avm-res-desktopvirtualization-hostpool" {
#   source                                             = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version                                            = "0.2.1"
#   resource_group_name                                = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location                 = var.location
#   virtual_desktop_host_pool_name                     = var.virtual_desktop_host_pool_name
#   virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type                     = var.virtual_desktop_host_pool_type
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
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }



# module "avm-res-desktopvirtualization-hostpool2" {
#   source                                             = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version                                            = "0.2.1"
#   resource_group_name                                = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location                 = var.location
#   virtual_desktop_host_pool_name                     = "avdhostpool-2"
#   virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type                     = "Pooled"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# module "avm-res-desktopvirtualization-hostpool3" {
#   source                                             = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version                                            = "0.2.1"
#   resource_group_name                                = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location                 = var.location
#   virtual_desktop_host_pool_name                     = "avdhostpool-3"
#   virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type                     = "Personal"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# module "avm-res-desktopvirtualization-hostpool4" {
#   source                                             = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
#   version                                            = "0.2.1"
#   resource_group_name                                = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
#   virtual_desktop_host_pool_location                 = var.location
#   virtual_desktop_host_pool_name                     = "avdhostpool-4"
#   virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
#   virtual_desktop_host_pool_type                     = "Personal"
#   virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
#   virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
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
#   subresource_names                             = ["feed"]
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# module "avm-res-desktopvirtualization-workspace2" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace2"
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
#   subresource_names                             = ["feed"]
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# module "avm-res-desktopvirtualization-workspace3" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace3"
#   subresource_names                             = ["global"]
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_global_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# module "avm-res-desktopvirtualization-workspace4" {
#   source                                        = "Azure/avm-res-desktopvirtualization-workspace/azurerm"
#   version                                       = "0.1.5"
#   resource_group_name                           = var.resource_group_name
#   virtual_desktop_workspace_location            = var.location
#   virtual_desktop_workspace_name                = "AVDWorkspace4"
#   subresource_names                             = ["global"]
#   virtual_desktop_workspace_resource_group_name = azurerm_resource_group.this.name
#   private_endpoints = {
#     primary = {
#       domain_name        = var.domain_global_name
#       subnet_resource_id = azurerm_subnet.example.id
#     }
#   }
# }

# resource "azurerm_virtual_desktop_application" "this" {
#   name                         = "test"
#   application_group_id         = module.avm-res-desktopvirtualization-applicationgroup1.resource_id
#   friendly_name                = "test"
#   description                  = "test"
#   path                         = "C:\\Program Files\\MyApp\\myapp.exe"
#   icon_path                    = "C:\\Program Files\\MyApp\\myapp.exe"
#   command_line_argument_policy = "Allow"
# }

# module "avm-res-operationalinsights-workspace" {
#   source              = "Azure/avm-res-operationalinsights-workspace/azurerm"
#   version             = "0.4.1"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name
#   name                = var.operationalinsights_workspace_name
# }


resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
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

  #Required variables
  network_interfaces = {
    example_nic = {
      name = "example-nic"
      ip_configurations = {
        ipconfig1 = {
          name                          = "internal"
          private_ip_subnet_resource_id = azurerm_subnet.example.id
        }
      }
    }
  }

  zone                = 1
  name                = "example-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_username      = "adminuser"
  admin_password      = "Password1234!"


  #Image configuration
  source_image_reference = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
  #Optional variables (add as needed)

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  tags = {
    environment = "production"
  }
}

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
