variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "The Azure location where the resources will be created"
  type        = string
  default     = "East US"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
  default     = "myLogAnalyticsWorkspace"
}

variable "sku" {
  description = "The SKU (pricing tier) of the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "The retention period for logs in days"
  type        = number
  default     = 30
}

variable "name" {
    description = "Law name"
    type = string
  
}