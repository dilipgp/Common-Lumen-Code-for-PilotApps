variable "tags" {
  type    = map(any)
  default = {}
}

variable "create_resource_group" {
  description = "Set this to true if a new RG is required."
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = null
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = null
  type        = string
}

###############################
# Azure Recovery Vault variables
###############################
variable "recovery_services_vault_name" {
  description = "Name of the Recovery Services Vault to be created"
  type        = string
}

variable "recovery_vault_sku" {
  description = "Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`."
  type        = string
  default     = "Standard"
}

variable "recovery_vault_storage_mode_type" {
  description = "The storage type of the Recovery Services Vault. Possible values are `GeoRedundant`, `LocallyRedundant` and `ZoneRedundant`. Defaults to `GeoRedundant`."
  type        = string
  default     = "LocallyRedundant"
}

variable "recovery_vault_cross_region_restore_enabled" {
  description = "Is cross region restore enabled for this Vault? Only can be `true`, when `storage_mode_type` is `GeoRedundant`. Defaults to `false`."
  type        = bool
  default     = false
}

variable "recovery_vault_soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to `true`."
  type        = bool
  default     = true
}

variable "recovery_vault_immutability" {
  description = "Immutability Settings of vault, possible values include: Locked, Unlocked and Disabled."
  default     = "Disabled"
  type        = string
}

variable "enable_encryption" {
  type    = bool
  default = false
}

variable "recovery_vault_identity_type" {
  description = "Azure Recovery Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}

##############################################
# Private Endpoint for Recovery Services Vault
##############################################
variable "enable_private_endpoint" {
  type    = bool
  default = false
}

variable "rcv_private_endpoint_name" {
  default = null
  type    = string
}

variable "subresource_names" {
  description = "Possible values are AzureBackup, AzureSiteRecovery."
  type        = list(string)
  default     = ["AzureBackup"]
}

variable "private_dns_zone_group_name" {
  type    = string
  default = "default"
}

variable "private_dns_zone_ids" {
  type    = list(string)
  default = null
}

##############################################
# Diagnostics settings for Recovery Services Vault
##############################################
variable "enable_diagnostics" {
  type    = bool
  default = true
}

variable "diagnostics_settings_name" {
  type    = string
  default = null
}

variable "subscription_id" {
  type    = string
  default = null
}

variable "pe_subnet_name" {
  type    = string
  default = null
}

variable "virtual_network_name" {
  default = null
  type    = string
}

variable "virtual_network_rg" {
  default = null
  type    = string
}

variable "vm_backup_policies" {
  description = "A list of backup policies for VMs."
  type = map(object({
    name                           = string
    policy_type                    = string
    timezone                       = string
    instant_restore_retention_days = optional(number)
    frequency                      = string
    time                           = string
    hour_interval                  = optional(number)
    hour_duration                  = optional(number)
    weekdays                       = optional(set(string))
    daily = optional(list(object({
      count = number
    })), [])
    weekly = optional(list(object({
      count    = number
      weekdays = optional(set(string))
    })), [])
    monthly = optional(list(object({
      count             = number
      weekdays          = optional(set(string))
      weeks             = optional(set(string))
      days              = optional(set(number))
      include_last_days = optional(bool)
    })), [])
    yearly = optional(list(object({
      count             = number
      weekdays          = optional(set(string))
      weeks             = optional(set(string))
      months            = optional(set(string))
      days              = optional(set(number))
      include_last_days = optional(bool)
    })), [])
  }))
  default = {}
}

variable "file_share_backup_policies" {
  description = "A list of backup policies for file shares."
  type = map(object({
    name                   = string
    timezone               = string
    frequency              = string
    time                   = string
    daily = optional(list(object({
      count = number
    })), [])
    weekly = optional(list(object({
      count    = number
      weekdays = set(string)
    })), [])
    monthly = optional(list(object({
      count             = number
      weekdays          = optional(set(string))
      weeks             = optional(set(string))
      days              = optional(set(number))
      include_last_days = optional(bool)
    })), [])
    yearly = optional(list(object({
      count             = number
      weekdays          = optional(set(string))
      weeks             = optional(set(string))
      months            = optional(set(string))
      days              = optional(set(number))
      include_last_days = optional(bool)
    })), [])
  }))
  default = {}
}

variable "logs_destinations_ids" {
  type    = list(string)
  default = []
}

variable "key_vault_key_name" {
  default = null
  type    = string
}

variable "key_vault_name" {
  default = null
  type    = string
}

variable "key_vault_rg_name" {
  default = null
  type    = string
}

variable "infrastructure_encryption_enabled" {
  default = false
  type    = bool
}

variable "kv_role_definition" {
  type    = string
  default = "Key Vault Crypto Service Encryption User"
}

variable "user_assigned_identity_rg_name" {
  default = null
  type    = string
}

variable "existing_user_assigned_identity_name" {
  default = null
  type    = string
}