resource "azurerm_log_analytics_linked_service" "management" {
  count = var.linked_automation_account_creation_enabled ? 1 : 0

  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  read_access_id      = var.read_access_id
  # write_access_id     = var.workspace_id
}

resource "azurerm_log_analytics_solution" "management" {
  for_each = { for plan in toset(var.log_analytics_solution_plans) : "${plan.publisher}/${plan.product}" => plan }

  location              = var.location
  resource_group_name   = var.resource_group_name
  solution_name         = basename(each.value.product)
  workspace_name        = var.log_analytics_workspace_name
  workspace_resource_id = var.workspace_id
  tags                  = var.tags

  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }

  depends_on = [
    azurerm_log_analytics_linked_service.management,
  ]
}