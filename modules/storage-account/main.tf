resource "azurerm_storage_account" "this" {
  account_replication_type          = var.account_replication_type
  account_tier                      = var.account_tier
  location                          = var.location
  name                              = var.name
  resource_group_name               = var.resource_group_name
  access_tier                       = var.account_kind == "BlockBlobStorage" && var.account_tier == "Premium" ? null : var.access_tier
  account_kind                      = var.account_kind
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  allowed_copy_scope                = var.allowed_copy_scope
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  edge_zone                         = var.edge_zone
  enable_https_traffic_only         = var.enable_https_traffic_only
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  is_hns_enabled                    = var.is_hns_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  min_tls_version                   = var.min_tls_version
  nfsv3_enabled                     = var.nfsv3_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  queue_encryption_key_type         = var.queue_encryption_key_type
  sftp_enabled                      = var.sftp_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  table_encryption_key_type         = var.table_encryption_key_type
  tags                              = var.tags

  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication == null ? [] : [
      var.azure_files_authentication
    ]
    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.active_directory == null ? [] : [
          azure_files_authentication.value.active_directory
        ]
        content {
          domain_guid         = active_directory.value.domain_guid
          domain_name         = active_directory.value.domain_name
          domain_sid          = active_directory.value.domain_sid
          forest_name         = active_directory.value.forest_name
          netbios_domain_name = active_directory.value.netbios_domain_name
          storage_sid         = active_directory.value.storage_sid
        }
      }
    }
  }
  dynamic "blob_properties" {
    for_each = var.blob_properties == null ? [] : [var.blob_properties]
    content {
      change_feed_enabled           = blob_properties.value.change_feed_enabled
      change_feed_retention_in_days = blob_properties.value.change_feed_retention_in_days
      default_service_version       = blob_properties.value.default_service_version
      last_access_time_enabled      = blob_properties.value.last_access_time_enabled
      versioning_enabled            = blob_properties.value.versioning_enabled

      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy == null ? [] : [
          blob_properties.value.container_delete_retention_policy
        ]
        content {
          days = container_delete_retention_policy.value.days
        }
      }
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule == null ? [] : blob_properties.value.cors_rule
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy == null ? [] : [
          blob_properties.value.delete_retention_policy
        ]
        content {
          days = delete_retention_policy.value.days
        }
      }
      dynamic "restore_policy" {
        for_each = blob_properties.value.restore_policy == null ? [] : [blob_properties.value.restore_policy]
        content {
          days = restore_policy.value.days
        }
      }
    }
  }
  dynamic "custom_domain" {
    for_each = var.custom_domain == null ? [] : [var.custom_domain]
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }
  dynamic "identity" {

    for_each = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? { this = var.managed_identities } : {}
    content {
      type         = identity.value.system_assigned && length(identity.value.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(identity.value.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  dynamic "immutability_policy" {
    for_each = var.immutability_policy == null ? [] : [var.immutability_policy]
    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
      state                         = immutability_policy.value.state
    }
  }
  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = var.network_rules.private_link_access == null ? [] : var.network_rules.private_link_access
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }

  }
  dynamic "queue_properties" {
    for_each = var.queue_properties == null ? [] : [var.queue_properties]
    content {
      dynamic "cors_rule" {
        for_each = queue_properties.value.cors_rule == null ? [] : queue_properties.value.cors_rule
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
      dynamic "hour_metrics" {
        for_each = queue_properties.value.hour_metrics == null ? [] : [queue_properties.value.hour_metrics]
        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = hour_metrics.value.include_apis
          retention_policy_days = hour_metrics.value.retention_policy_days
        }
      }
      dynamic "logging" {
        for_each = queue_properties.value.logging == null ? [] : [queue_properties.value.logging]
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          version               = logging.value.version
          write                 = logging.value.write
          retention_policy_days = logging.value.retention_policy_days
        }
      }
      dynamic "minute_metrics" {
        for_each = queue_properties.value.minute_metrics == null ? [] : [queue_properties.value.minute_metrics]
        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = minute_metrics.value.include_apis
          retention_policy_days = minute_metrics.value.retention_policy_days
        }
      }
    }
  }
  dynamic "routing" {
    for_each = var.routing == null ? [] : [var.routing]
    content {
      choice                      = routing.value.choice
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
    }
  }
  dynamic "sas_policy" {
    for_each = var.sas_policy == null ? [] : [var.sas_policy]
    content {
      expiration_period = sas_policy.value.expiration_period
      expiration_action = sas_policy.value.expiration_action
    }
  }
  dynamic "share_properties" {
    for_each = var.share_properties == null ? [] : [var.share_properties]
    content {
      dynamic "cors_rule" {
        for_each = share_properties.value.cors_rule == null ? [] : share_properties.value.cors_rule
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
      dynamic "retention_policy" {
        for_each = share_properties.value.retention_policy == null ? [] : [share_properties.value.retention_policy]
        content {
          days = retention_policy.value.days
        }
      }
      dynamic "smb" {
        for_each = share_properties.value.smb == null ? [] : [share_properties.value.smb]
        content {
          authentication_types            = smb.value.authentication_types
          channel_encryption_type         = smb.value.channel_encryption_type
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type
          multichannel_enabled            = smb.value.multichannel_enabled
          versions                        = smb.value.versions
        }
      }
    }
  }
  dynamic "static_website" {
    for_each = var.static_website == null ? [] : [var.static_website]
    content {
      error_404_document = static_website.value.error_404_document
      index_document     = static_website.value.index_document
    }
  }
  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

resource "azurerm_storage_account_local_user" "this" {
  for_each = var.local_user

  name                 = each.value.name
  storage_account_id   = azurerm_storage_account.this.id
  home_directory       = each.value.home_directory
  ssh_key_enabled      = each.value.ssh_key_enabled
  ssh_password_enabled = each.value.ssh_password_enabled

  dynamic "permission_scope" {
    for_each = each.value.permission_scope == null ? [] : each.value.permission_scope
    content {
      resource_name = permission_scope.value.resource_name
      service       = permission_scope.value.service

      dynamic "permissions" {
        for_each = [permission_scope.value.permissions]
        content {
          create = permissions.value.create
          delete = permissions.value.delete
          list   = permissions.value.list
          read   = permissions.value.read
          write  = permissions.value.write
        }
      }
    }
  }
  dynamic "ssh_authorized_key" {
    for_each = each.value.ssh_authorized_key == null ? [] : each.value.ssh_authorized_key
    content {
      key         = ssh_authorized_key.value.key
      description = ssh_authorized_key.value.description
    }
  }
  dynamic "timeouts" {
    for_each = each.value.timeouts == null ? [] : [each.value.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}


resource "azurerm_storage_account_customer_managed_key" "this" {
  count = var.customer_managed_key != null ? 1 : 0

  key_name                  = var.customer_managed_key.key_name
  storage_account_id        = azurerm_storage_account.this.id
  key_vault_id              = var.customer_managed_key.key_vault_resource_id
  key_version               = var.customer_managed_key.key_version
  user_assigned_identity_id = var.customer_managed_key.user_assigned_identity.resource_id

  lifecycle {
    precondition {
      condition     = (var.account_kind == "StorageV2" || var.account_tier == "Premium")
      error_message = "`var.customer_managed_key` can only be set when the `account_kind` is set to `StorageV2` or `account_tier` set to `Premium`, and the identity type is `UserAssigned`."
    }
  }
}

# resource "azurerm_role_assignment" "storage_account" {
#   for_each = var.role_assignments

#   principal_id                           = each.value.principal_id
#   scope                                  = azurerm_storage_account.this.id
#   condition                              = each.value.condition
#   condition_version                      = each.value.condition_version
#   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
#   role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
#   role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
#   skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
# }

# variable "shares" {
#   type = map(object({
#     access_tier      = optional(string)
#     enabled_protocol = optional(string)
#     metadata         = optional(map(string))
#     name             = string
#     quota            = number
#     root_squash      = optional(string)
#     signed_identifiers = optional(list(object({
#       id = string
#       access_policy = optional(object({
#         expiry_time = string
#         permission  = string
#         start_time  = string
#       }))
#     })))
#     role_assignments = optional(map(object({
#       role_definition_id_or_name             = string
#       principal_id                           = string
#       description                            = optional(string, null)
#       skip_service_principal_aad_check       = optional(bool, false)
#       condition                              = optional(string, null)
#       condition_version                      = optional(string, null)
#       delegated_managed_identity_resource_id = optional(string, null)
#     })), {})
#     timeouts = optional(object({
#       create = optional(string)
#       delete = optional(string)
#       read   = optional(string)
#       update = optional(string)
#     }))
#   }))
#   default     = {}
#   description = <<-EOT
#  - `access_tier` - (Optional) The access tier of the File Share. Possible values are `Hot`, `Cool` and `TransactionOptimized`, `Premium`.
#  - `enabled_protocol` - (Optional) The protocol used for the share. Possible values are `SMB` and `NFS`. The `SMB` indicates the share can be accessed by SMBv3.0, SMBv2.1 and REST. The `NFS` indicates the share can be accessed by NFSv4.1. Defaults to `SMB`. Changing this forces a new resource to be created.
#  - `metadata` - (Optional) A mapping of MetaData for this File Share.
#  - `name` - (Required) The name of the share. Must be unique within the storage account where the share is located. Changing this forces a new resource to be created.
#  - `quota` - (Required) The maximum size of the share, in gigabytes. For Standard storage accounts, this must be `1`GB (or higher) and at most `5120` GB (`5` TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and at most `102400` GB (`100` TB).

#  ---
#  `acl` block supports the following:
#  - `id` - (Required) The ID which should be used for this Shared Identifier.

#  ---
#  `access_policy` block supports the following:
#  - `expiry` - (Optional) The time at which this Access Policy should be valid until, in [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) format.
#  - `permissions` - (Required) The permissions which should be associated with this Shared Identifier. Possible value is combination of `r` (read), `w` (write), `d` (delete), and `l` (list).
#  - `start` - (Optional) The time at which this Access Policy should be valid from, in [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) format.

#  ---
#  `timeouts` block supports the following:
#  - `create` - (Defaults to 30 minutes) Used when creating the Storage Share.
#  - `delete` - (Defaults to 30 minutes) Used when deleting the Storage Share.
#  - `read` - (Defaults to 5 minutes) Used when retrieving the Storage Share.
#  - `update` - (Defaults to 30 minutes) Used when updating the Storage Share.

# Supply role assignments in the same way as for `var.role_assignments`.

# EOT
#   nullable    = false
# }

# variable "share_properties" {
#   type = object({
#     cors_rule = optional(list(object({
#       allowed_headers    = list(string)
#       allowed_methods    = list(string)
#       allowed_origins    = list(string)
#       exposed_headers    = list(string)
#       max_age_in_seconds = number
#     })))
#     diagnostic_settings = optional(map(object({
#       name                                     = optional(string, null)
#       log_categories                           = optional(set(string), [])
#       log_groups                               = optional(set(string), ["allLogs"])
#       metric_categories                        = optional(set(string), ["AllMetrics"])
#       log_analytics_destination_type           = optional(string, "Dedicated")
#       workspace_resource_id                    = optional(string, null)
#       resource_id                              = optional(string, null)
#       event_hub_authorization_rule_resource_id = optional(string, null)
#       event_hub_name                           = optional(string, null)
#       marketplace_partner_resource_id          = optional(string, null)
#     })), {})
#     retention_policy = optional(object({
#       days = optional(number)
#     }))
#     smb = optional(object({
#       authentication_types            = optional(set(string))
#       channel_encryption_type         = optional(set(string))
#       kerberos_ticket_encryption_type = optional(set(string))
#       multichannel_enabled            = optional(bool)
#       versions                        = optional(set(string))
#     }))
#   })
#   default     = null
#   description = <<-EOT

#  ---
#  `cors_rule` block supports the following:
#  - `allowed_headers` - (Required) A list of headers that are allowed to be a part of the cross-origin request.
#  - `allowed_methods` - (Required) A list of HTTP methods that are allowed to be executed by the origin. Valid options are `DELETE`, `GET`, `HEAD`, `MERGE`, `POST`, `OPTIONS`, `PUT` or `PATCH`.
#  - `allowed_origins` - (Required) A list of origin domains that will be allowed by CORS.
#  - `exposed_headers` - (Required) A list of response headers that are exposed to CORS clients.
#  - `max_age_in_seconds` - (Required) The number of seconds the client should cache a preflight response.

#  ---
#  `diagnostic_settings` block supports the following:
#  - `name` - (Optional) The name of the diagnostic setting. Defaults to `null`.
#  - `log_categories` - (Optional) A set of log categories to enable. Defaults to an empty set.
#  - `log_groups` - (Optional) A set of log groups to enable. Defaults to `["allLogs"]`.
#  - `metric_categories` - (Optional) A set of metric categories to enable. Defaults to `["AllMetrics"]`.
#  - `log_analytics_destination_type` - (Optional) The destination type for log analytics. Defaults to `"Dedicated"`.
#  - `workspace_resource_id` - (Optional) The resource ID of the Log Analytics workspace. Defaults to `null`.
#  - `resource_id` - (Optional) The resource ID of the target resource for diagnostics. Defaults to `null`.
#  - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the Event Hub authorization rule. Defaults to `null`.
#  - `event_hub_name` - (Optional) The name of the Event Hub. Defaults to `null`.
#  - `marketplace_partner_resource_id` - (Optional) The resource ID of the marketplace partner. Defaults to `null`.

#  ---
#  `retention_policy` block supports the following:
#  - `days` - (Optional) Specifies the number of days that the `azurerm_shares` should be retained, between `1` and `365` days. Defaults to `7`.

#  ---
#  `smb` block supports the following:
#  - `authentication_types` - (Optional) A set of SMB authentication methods. Possible values are `NTLMv2`, and `Kerberos`.
#  - `channel_encryption_type` - (Optional) A set of SMB channel encryption. Possible values are `AES-128-CCM`, `AES-128-GCM`, and `AES-256-GCM`.
#  - `kerberos_ticket_encryption_type` - (Optional) A set of Kerberos ticket encryption. Possible values are `RC4-HMAC`, and `AES-256`.
#  - `multichannel_enabled` - (Optional) Indicates whether multichannel is enabled. Defaults to `false`. This is only supported on Premium storage accounts.
#  - `versions` - (Optional) A set of SMB protocol versions. Possible values are `SMB2.1`, `SMB3.0`, and `SMB3.1.1`.
# EOT
# }

# variable "large_file_share_enabled" {
#   type        = bool
#   default     = null
#   description = "(Optional) Is Large File Share Enabled?"
# }

# variable "azure_files_authentication" {
#   type = object({
#     directory_type = string
#     active_directory = optional(object({
#       domain_guid         = string
#       domain_name         = string
#       domain_sid          = string
#       forest_name         = string
#       netbios_domain_name = string
#       storage_sid         = string
#     }))
#   })
#   default     = null
#   description = <<-EOT
#  - `directory_type` - (Required) Specifies the directory service used. Possible values are `AADDS`, `AD` and `AADKERB`.

#  ---
#  `active_directory` block supports the following:
#  - `domain_guid` - (Required) Specifies the domain GUID.
#  - `domain_name` - (Required) Specifies the primary domain that the AD DNS server is authoritative for.
#  - `domain_sid` - (Required) Specifies the security identifier (SID).
#  - `forest_name` - (Required) Specifies the Active Directory forest.
#  - `netbios_domain_name` - (Required) Specifies the NetBIOS domain name.
#  - `storage_sid` - (Required) Specifies the security identifier (SID) for Azure Storage.
# EOT
# }
