locals {
  # Custom domain verification id
  custom_domain_verification_id = (var.kind == "functionapp" || var.kind == "webapp") ? (var.kind == "functionapp" ? (var.os_type == "Windows" ? azurerm_windows_function_app.this[0].custom_domain_verification_id : azurerm_linux_function_app.this[0].custom_domain_verification_id) : (var.os_type == "Windows" ? azurerm_windows_web_app.this[0].custom_domain_verification_id : azurerm_linux_web_app.this[0].custom_domain_verification_id)) : null
  # Managed identities
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
}