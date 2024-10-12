# This is required for resource modules
data "azurerm_resource_group" "this" {
  name = "lumen-avd-rg-03"
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

data "azurerm_key_vault" "vault" {
  name                = "avd-domainjoin-for-lumen" # Replace with your Key Vault name
  resource_group_name = "AD"                       # Replace with the resource group name where the Key Vault is deployed
}
 
# Retrieve the domain join username from Azure Key Vault
data "azurerm_key_vault_secret" "domain_username" {
  name         = "domain-join-account-username"
  key_vault_id = data.azurerm_key_vault.vault.id
  #key_vault_id = "/subscriptions/8ac116fa-33ed-4b86-a94e-f39228fecb4a/resourceGroups/AD/providers/Microsoft.KeyVault/vaults/avd-domainjoin-for-lumen"
}
# Retrieve the domain join password from Azure Key Vault
data "azurerm_key_vault_secret" "domain_password" {
  name         = "domain-join-account-password"
  key_vault_id = data.azurerm_key_vault.vault.id
  #key_vault_id = "/subscriptions/8ac116fa-33ed-4b86-a94e-f39228fecb4a/resourceGroups/AD/providers/Microsoft.KeyVault/vaults/avd-domainjoin-for-lumen"
}

output "secret_value" {
  value = data.azurerm_key_vault_secret.domain_password.value
}

output "secret_value2" {
  value = data.azurerm_key_vault_secret.domain_username.value
}
 
