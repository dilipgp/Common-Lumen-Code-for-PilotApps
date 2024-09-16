output "log_analytics_workspace" {
  description = "A curated output of the Log Analytics Workspace."
  value = {
    id                   = azurerm_log_analytics_workspace.law.id
    name                 = azurerm_log_analytics_workspace.law.name
    workspace_id         = azurerm_log_analytics_workspace.law.workspace_id
  }
}