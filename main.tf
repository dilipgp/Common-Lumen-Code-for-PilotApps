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

}

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
  legacy_access_policies_enabled = true
#  legacy_access_policies = {
#     test = {
#       object_id               = data.azurerm_client_config.this.object_id
#       secret_permissions      = ["Get","List","Set"]
#     }
#     


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
# data "azurerm_key_vault" "vault" {
#   name                = "avd-domainjoin-for-lumen" # Replace with your Key Vault name
#   resource_group_name = "AD"                       # Replace with the resource group name where the Key Vault is deployed
# }
 
# # Retrieve the domain join username from Azure Key Vault
# data "azurerm_key_vault_secret" "domain_username" {
#   name         = "domain-join-account-username"
#   key_vault_id = data.azurerm_key_vault.vault.id
#   #key_vault_id = "/subscriptions/8ac116fa-33ed-4b86-a94e-f39228fecb4a/resourceGroups/AD/providers/Microsoft.KeyVault/vaults/avd-domainjoin-for-lumen"
# }
# # Retrieve the domain join password from Azure Key Vault
# data "azurerm_key_vault_secret" "domain_password" {
#   name         = "domain-join-account-password"
#   key_vault_id = data.azurerm_key_vault.vault.id
#   #key_vault_id = "/subscriptions/8ac116fa-33ed-4b86-a94e-f39228fecb4a/resourceGroups/AD/providers/Microsoft.KeyVault/vaults/avd-domainjoin-for-lumen"
# }
 
# resource "azurerm_virtual_machine_extension" "vm1ext_domain_join" {
#   name                       = "ExtensionName1GoesHere"
#   for_each                   = azurerm_windows_virtual_machine.winvm // Your key logic here
#   virtual_machine_id         = azurerm_windows_virtual_machine.winvm[each.key].id
#   publisher                  = "Microsoft.Compute"
#   type                       = "JsonADDomainExtension"
#   type_handler_version       = "1.3"
#   auto_upgrade_minor_version = true
 
#   settings = <<-SETTINGS
#     {
#       "Name": "ditclouds.com",
#       "OUPath": "OU=AVD-Hosts,DC=ditclouds,DC=com",
#       "User": "${data.azurerm_key_vault_secret.domain_username.value}",
#       "Restart": "true",
#       "Options": "3"
#     }
#     SETTINGS
 
#   protected_settings = <<-PSETTINGS
#     {
#       "Password": "${data.azurerm_key_vault_secret.domain_password.value}"
#     }
#     PSETTINGS
 
#   lifecycle {
#     ignore_changes = [settings, protected_settings]
#   }
# }
 
# # Generate a random password
# resource "random_password" "password" {
#   length  = 16
#   special = true
# }
 
# # Store the admin username in the existing Azure Key Vault
# resource "azurerm_key_vault_secret" "winvm_username" {
#   for_each     = azurerm_windows_virtual_machine.winvm
#   name         = "${each.value.name}-Username-"
#   value        = each.value.admin_username
#   key_vault_id = data.azurerm_key_vault.vault.id
# }
# # Store the generated password in the existing Azure Key Vault
# resource "azurerm_key_vault_secret" "winvm_password" {
#   for_each     = azurerm_windows_virtual_machine.winvm
#   name         = "${each.value.name}-Password"
#   value        = random_password.password.result
#   key_vault_id = data.azurerm_key_vault.vault.id
#}
# resource "azurerm_key_vault_access_policy" "deploy" {
#   key_vault_id = module.avm-res-keyvault-vault.resource_id
#   tenant_id    = "c925fe9d-30b1-4191-acbf-4109845df16f"
#   object_id    = "08afb591-fb58-46c1-b797-76688967a5cf"

#   key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover"]
#   secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
#   certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover"]
#   storage_permissions     = ["Get", "List", "Update", "Delete"]
# }
 
# # Generate a random password
# resource "random_password" "password" {
#   length  = 16
#   special = true
# }
# # Create a secret in Key Vault using the random password
# resource "azurerm_key_vault_secret" "example" {
#   name         = "example-secret"
#   value        = random_password.password.result
#   key_vault_id = module.avm-res-keyvault-vault.resource_id
# }

# # Output to display the secret's name and value
# output "key_vault_secret" {
#   value = {
#     secret_name  = azurerm_key_vault_secret.example.name
#     secret_value = azurerm_key_vault_secret.example.value
#   }
  
#   # Mark as sensitive to avoid exposing the secret value in logs
#   sensitive = true
# }

# # Data source to get Azure Client configuration (tenant and object ID)
# data "azurerm_client_config" "example" {}
 
module "azure_bastion" {
  source = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"
  enable_telemetry    = true
  resource_group_name = var.resource_group_name
  location = var.location
  name = "avd-bastion"
  copy_paste_enabled     = true
  file_copy_enabled      = false
  sku                 = "Standard"  # Change to Premium SKU
  ip_configuration = {
    name                 = "my-ipconfig"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = null  # Set to null to use private IP
  }
  ip_connect_enabled     = true
  scale_units            = 4
  shareable_link_enabled = true
  tunneling_enabled      = true
  kerberos_enabled       = true
 
  tags = {
    environment = "production"
  }
}

resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.bastion.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}
 
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "example-link"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.example.id
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
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# resource "azurerm_management_lock" "vnet_lock_test" {
#   name       = "vnet-lock"
#   scope      = azurerm_virtual_network.example.id
#   lock_level = "CanNotDelete"
# }

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/27"]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.10.2.0/24"]
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

