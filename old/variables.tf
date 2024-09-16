
variable "rg_name" {
    description = "Rg name"
    type = string
    nullable    = false
}

variable "rg_location" {
  description = "The Azure location where the resources will be created"
  type        = string
  default     = "East US"
  nullable    = false
}

variable "law_resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "law_location" {
  description = "The Azure location where the resources will be created"
  type        = string
  default     = "East US"
}

variable "law_log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
  default     = "myLogAnalyticsWorkspace"
}

variable "law_sku" {
  description = "The SKU (pricing tier) of the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "law_retention_in_days" {
  description = "The retention period for logs in days"
  type        = number
  default     = 30
}

variable "law_name" {
    description = "Law name"
    type = string  
}

variable "aa_name" {
    description = "Law name"
    type = string  
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "kv_name" {
    description = "key vault name"
    type = string  
}

variable "vnet_name" {
    description = "key vault name"
    type = string  
}

variable "strg_acct_name" {
    description = "storage account name"
    type = string  
}

variable "kind" {
    description = "web/function app kind"
    type = string  
}

variable "os_type" {
    description = "web/function app os type"
    type = string  
}

variable "bypass_ip_cidr" {
  type        = string
  default     = null
  description = "value to bypass the IP CIDR on firewall rules"
}

variable "msi_id" {
  type        = string
  default     = null
  description = "If you're running this example by authentication with identity, please set identity object id here."
}

variable "aks_name" {
    description = "aks name"
    type = string  
}

# variable "node_pools" {
#   description = "Map of settings for the node pool"
#   type        = map(string)
# }