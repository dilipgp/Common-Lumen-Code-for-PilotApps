#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}

#---------------------------------------------------------
# Data Sources
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

data "azurerm_key_vault" "kv" {
  count               = var.enable_encryption ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_key" "kv_key" {
  count        = var.enable_encryption ? 1 : 0
  name         = var.key_vault_key_name
  key_vault_id = data.azurerm_key_vault.kv[0].id
}

data "azurerm_user_assigned_identity" "this" {
  count               = var.recovery_vault_identity_type == "UserAssigned" || var.recovery_vault_identity_type == "SystemAssigned, UserAssigned" ? 1 : 0
  name                = var.existing_user_assigned_identity_name
  resource_group_name = var.user_assigned_identity_rg_name
}

#---------------------------------------------------------
# Recovery Services Vault resource creation
#----------------------------------------------------------
resource "azurerm_recovery_services_vault" "vault" {
  name                          = var.recovery_services_vault_name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  sku                           = var.recovery_vault_sku
  storage_mode_type             = var.recovery_vault_storage_mode_type
  cross_region_restore_enabled  = var.recovery_vault_cross_region_restore_enabled
  soft_delete_enabled           = var.recovery_vault_soft_delete_enabled
  public_network_access_enabled = false
  immutability                  = var.recovery_vault_immutability
  tags                          = var.tags

  identity {
    type         = var.recovery_vault_identity_type
    identity_ids = var.recovery_vault_identity_type == "UserAssigned" || var.recovery_vault_identity_type == "SystemAssigned, UserAssigned" ? [data.azurerm_user_assigned_identity.this[0].id] : null
  }

  # encryption {
  #   key_id                            = var.enable_encryption ? data.azurerm_key_vault_key.kv_key[0].id : null
  #   infrastructure_encryption_enabled = var.enable_encryption ? var.infrastructure_encryption_enabled : false
  #   user_assigned_identity_id         = var.enable_encryption && var.recovery_vault_identity_type == "UserAssigned" ? data.azurerm_user_assigned_identity.this[0].id : null
  #   use_system_assigned_identity      = var.enable_encryption && var.recovery_vault_identity_type != "UserAssigned" ? true : false
  # }
}

resource "azurerm_role_assignment" "this" {
  count                            = var.enable_encryption ? 1 : 0
  scope                            = data.azurerm_key_vault.kv[0].id
  role_definition_name             = var.kv_role_definition
  principal_id                     = var.recovery_vault_identity_type == "UserAssigned" ? data.azurerm_user_assigned_identity.this[0].principal_id : azurerm_recovery_services_vault.vault.identity[0].principal_id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_recovery_services_vault.vault]
}

#---------------------------------------------------------
# Backup Policy for VMs
#---------------------------------------------------------
resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  for_each                       = var.vm_backup_policies
  name                           = each.value.name
  resource_group_name            = local.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.vault.name
  policy_type                    = each.value.policy_type
  timezone                       = each.value.timezone
  instant_restore_retention_days = each.value.instant_restore_retention_days

  backup {
    frequency     = each.value.frequency
    time          = each.value.time
    hour_duration = each.value.hour_duration
    hour_interval = each.value.hour_interval
    weekdays      = each.value.weekdays
  }

  dynamic "retention_daily" {
    for_each = each.value.daily
    content {
      count = retention_daily.value.count
    }
  }

  dynamic "retention_weekly" {
    for_each = each.value.weekly
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = each.value.monthly
    content {
      count             = retention_monthly.value.count
      weekdays          = retention_monthly.value.weekdays
      weeks             = retention_monthly.value.weeks
      days              = retention_monthly.value.days
      include_last_days = retention_monthly.value.include_last_days
    }
  }

  dynamic "retention_yearly" {
    for_each = each.value.yearly
    content {
      count             = retention_yearly.value.count
      weekdays          = retention_yearly.value.weekdays
      weeks             = retention_yearly.value.weeks
      months            = retention_yearly.value.months
      days              = retention_yearly.value.days
      include_last_days = retention_yearly.value.include_last_days
    }
  }
}

#---------------------------------------------------------
# File share backup policy
#---------------------------------------------------------
resource "azurerm_backup_policy_file_share" "file_share_backup_policy" {
  for_each            = var.file_share_backup_policies
  name                = each.value.name
  resource_group_name = local.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  timezone            = each.value.timezone

  backup {
    frequency = each.value.frequency
    time      = each.value.time
  }

  dynamic "retention_daily" {
    for_each = each.value.daily
    content {
      count = retention_daily.value.count
    }
  }

  dynamic "retention_weekly" {
    for_each = each.value.weekly
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = each.value.monthly
    content {
      count             = retention_monthly.value.count
      weekdays          = retention_monthly.value.weekdays
      weeks             = retention_monthly.value.weeks
      days              = retention_monthly.value.days
      include_last_days = retention_monthly.value.include_last_days
    }
  }

  dynamic "retention_yearly" {
    for_each = each.value.yearly
    content {
      count             = retention_yearly.value.count
      weekdays          = retention_yearly.value.weekdays
      weeks             = retention_yearly.value.weeks
      months            = retention_yearly.value.months
      days              = retention_yearly.value.days
      include_last_days = retention_yearly.value.include_last_days
    }
  }
}

#---------------------------------------------------------------
# Resource creation: Key Vault Private Endpoint
#---------------------------------------------------------------
resource "azurerm_private_endpoint" "this" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = var.rcv_private_endpoint_name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = "/subscriptions/${var.subscription_id}/resourceGroups/${var.virtual_network_rg}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}/subnets/${var.pe_subnet_name}"

  private_service_connection {
    name                           = "${azurerm_recovery_services_vault.vault.name}-psc"
    private_connection_resource_id = azurerm_recovery_services_vault.vault.id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
    request_message                = null
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags       = var.tags
  # depends_on = [azurerm_recovery_services_vault.vault, module.rcv_diagnostics]
}

#--------------------------------------------------------------
# Diagnostics Settings
#--------------------------------------------------------------
# module "rcv_diagnostics" {
#   count                     = var.enable_diagnostics ? 1 : 0
#   source                    = "../terraform-azure-diagnostics-settings"
#   resource_id               = azurerm_recovery_services_vault.vault.id
#   diagnostics_settings_name = var.diagnostics_settings_name
#   logs_destinations_ids     = var.logs_destinations_ids
#   depends_on                = [azurerm_recovery_services_vault.vault]
# }