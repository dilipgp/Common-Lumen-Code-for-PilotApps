variable "linked_automation_account_creation_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to determine whether to deploy the Azure Automation Account linked to the Log Analytics Workspace or not."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the resources will be created."
}

variable "log_analytics_solution_plans" {
  type = list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
  default = [
    {
      product   = "OMSGallery/AgentHealthAssessment"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/AntiMalware"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ChangeTracking"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/Security"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/SecurityInsights"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/ServiceMap"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/SQLAdvancedThreatProtection"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/SQLAssessment"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/SQLVulnerabilityAssessment"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/Updates"
      publisher = "Microsoft"
    },
    {
      product   = "OMSGallery/VMInsights"
      publisher = "Microsoft"
    },
  ]
  description = "The Log Analytics Solution Plans to create."
  nullable    = false
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
}


variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "workspace_id" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "read_access_id" {
  type        = string
  description = "The name of the Log Analytics Workspace to create."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to apply to the resources created."
}