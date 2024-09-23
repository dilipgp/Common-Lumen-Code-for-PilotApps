# Create Azure Virtual Desktop host pool
resource "azurerm_virtual_desktop_host_pool" "this" {
  load_balancer_type               = var.virtual_desktop_host_pool_load_balancer_type
  location                         = var.virtual_desktop_host_pool_location
  name                             = var.virtual_desktop_host_pool_name
  resource_group_name              = var.virtual_desktop_host_pool_resource_group_name
  type                             = var.virtual_desktop_host_pool_type
  custom_rdp_properties            = var.virtual_desktop_host_pool_custom_rdp_properties
  description                      = var.virtual_desktop_host_pool_description
  friendly_name                    = var.virtual_desktop_host_pool_friendly_name
  maximum_sessions_allowed         = var.virtual_desktop_host_pool_maximum_sessions_allowed
  personal_desktop_assignment_type = var.virtual_desktop_host_pool_personal_desktop_assignment_type
  preferred_app_group_type         = var.virtual_desktop_host_pool_preferred_app_group_type
  start_vm_on_connect              = var.virtual_desktop_host_pool_start_vm_on_connect
  tags                             = var.virtual_desktop_host_pool_tags
  validate_environment             = var.virtual_desktop_host_pool_validate_environment
  vm_template                      = jsonencode(var.virtual_desktop_host_pool_vm_template)

  dynamic "scheduled_agent_updates" {
    for_each = var.virtual_desktop_host_pool_scheduled_agent_updates == null ? [] : [var.virtual_desktop_host_pool_scheduled_agent_updates]
    content {
      enabled                   = scheduled_agent_updates.value.enabled
      timezone                  = scheduled_agent_updates.value.timezone
      use_session_host_timezone = scheduled_agent_updates.value.use_session_host_timezone

      dynamic "schedule" {
        for_each = scheduled_agent_updates.value.schedule == null ? [] : scheduled_agent_updates.value.schedule
        content {
          day_of_week = schedule.value.day_of_week
          hour_of_day = schedule.value.hour_of_day
        }
      }
    }
  }
  dynamic "timeouts" {
    for_each = var.virtual_desktop_host_pool_timeouts == null ? [] : [var.virtual_desktop_host_pool_timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  lifecycle {
    ignore_changes = [custom_rdp_properties]
  }
}

# Registration information for the host pool.
resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  expiration_date = timeadd(timestamp(), var.registration_expiration_period)
  hostpool_id     = azurerm_virtual_desktop_host_pool.this.id

  lifecycle {
    ignore_changes = [
      expiration_date,
      hostpool_id,
    ]
  }
}

# Create Diagnostic Settings for AVD Host Pool
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.virtual_desktop_host_pool_name}"
  target_resource_id             = azurerm_virtual_desktop_host_pool.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoints

  location                      = each.value.location != null ? each.value.location : var.virtual_desktop_host_pool_location
  name                          = each.value.name != null ? each.value.name : "pe-${var.virtual_desktop_host_pool_name}"
  resource_group_name           = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  subnet_id                     = each.value.subnet_resource_id
  custom_network_interface_name = each.value.network_interface_name
  tags                          = each.value.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = each.value.private_service_connection_name != null ? each.value.private_service_connection_name : "pse-${var.virtual_desktop_host_pool_name}"
    private_connection_resource_id = azurerm_virtual_desktop_host_pool.this.id
    subresource_names              = ["connection"]
  }
  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      member_name        = "connection"
      subresource_name   = "connection"
    }
  }
  dynamic "private_dns_zone_group" {
    for_each = length(each.value.private_dns_zone_resource_ids) > 0 ? ["this"] : []

    content {
      name                 = each.value.private_dns_zone_group_name
      private_dns_zone_ids = each.value.private_dns_zone_resource_ids
    }
  }
}

resource "azurerm_private_endpoint_application_security_group_association" "this" {
  for_each = local.private_endpoint_application_security_group_associations

  application_security_group_id = each.value.asg_resource_id
  private_endpoint_id           = azurerm_private_endpoint.this[each.value.pe_key].id
}