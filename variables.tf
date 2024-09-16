variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
  nullable    = false
}

variable "keyvault_name" {
  type        = string
  description = "The name of the Key Vault to create."
  nullable    = false
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID to use for the Key Vault."
  nullable    = false
}

variable "location" {
  type        = string
  description = "The Azure region where the resources should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns_prefix if it is set)"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]$|^[a-zA-Z0-9][-_a-zA-Z0-9]{0,61}[a-zA-Z0-9]$", var.name))
    error_message = "Check naming rules here https://learn.microsoft.com/en-us/rest/api/aks/managed-clusters/create-or-update?view=rest-aks-2023-10-01&tabs=HTTP"
  }
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Specify which Kubernetes release to use. Specify only minor version, such as '1.28'."
}

variable "node_cidr" {
  type        = string
  default     = null
  description = "(Optional) The CIDR to use for node IPs in the Kubernetes cluster. Changing this forces a new resource to be created."
}

variable "pod_cidr" {
  type        = string
  default     = null
  description = "(Optional) The CIDR to use for pod IPs in the Kubernetes cluster. Changing this forces a new resource to be created."
}

variable "node_pools" {
  type = map(object({
    name                 = string
    vm_size              = string
    orchestrator_version = string
    # do not add nodecount because we enforce the use of auto-scaling
    max_count       = optional(number)
    min_count       = optional(number)
    os_sku          = optional(string)
    mode            = optional(string)
    os_disk_size_gb = optional(number, null)
    tags            = optional(map(string), {})
    zones           = optional(set(string))
  }))
  default     = {}
  description = <<-EOT
A map of node pools that need to be created and attached on the Kubernetes cluster. The key of the map can be the name of the node pool, and the key must be static string. The value of the map is a `node_pool` block as defined below:
map(object({
  name                 = (Required) The name of the Node Pool which should be created within the Kubernetes Cluster. Changing this forces a new resource to be created. A Windows Node Pool cannot have a `name` longer than 6 characters. A random suffix of 4 characters is always added to the name to avoid clashes during recreates.
  vm_size              = (Required) The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created.
  orchestrator_version = (Required) The version of Kubernetes which should be used for this Node Pool. Changing this forces a new resource to be created.
  max_count            = (Optional) The maximum number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` and must be greater than or equal to `min_count`.
  min_count            = (Optional) The minimum number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` and must be less than or equal to `max_count`.
  os_sku               = (Optional) Specifies the OS SKU used by the agent pool. Possible values include: `Ubuntu`, `CBLMariner`, `Mariner`, `Windows2019`, `Windows2022`. If not specified, the default is `Ubuntu` if OSType=Linux or `Windows2019` if OSType=Windows. And the default Windows OSSKU will be changed to `Windows2022` after Windows2019 is deprecated. Changing this forces a new resource to be created.
  mode                 = (Optional) Should this Node Pool be used for System or User resources? Possible values are `System` and `User`. Defaults to `User`.
  os_disk_size_gb      = (Optional) The Agent Operating System disk size in GB. Changing this forces a new resource to be created.
  tags                 = (Optional) A mapping of tags to assign to the resource. At this time there's a bug in the AKS API where Tags for a Node Pool are not stored in the correct case - you [may wish to use Terraform's `ignore_changes` functionality to ignore changes to the casing](https://www.terraform.io/language/meta-arguments/lifecycle#ignore_changess) until this is fixed in the AKS API.
  zones                = (Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located. Changing this forces a new Kubernetes Cluster Node Pool to be created.
}))

EOT
  nullable    = false
}

variable "virtual_desktop_application_group_name" {
  type        = string
  default     = "vdag-avd-001"
  description = "The name of the AVD Application Group."

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.virtual_desktop_application_group_name))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "virtual_desktop_application_group_type" {
  type        = string
  default     = "Desktop"
  description = "The type of the AVD Application Group. Valid values are 'Desktop' and 'RemoteApp'."
}

variable "virtual_desktop_host_pool_friendly_name" {
  type        = string
  default     = "AVD Host Pool"
  description = "(Optional) A friendly name for the Virtual Desktop Host Pool."
}

variable "virtual_desktop_host_pool_load_balancer_type" {
  type        = string
  default     = "BreadthFirst"
  description = "`BreadthFirst` load balancing distributes new user sessions across all available session hosts in the host pool. Possible values are `BreadthFirst`, `DepthFirst` and `Persistent`. `DepthFirst` load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. `Persistent` should be used if the host pool type is `Personal`"
}

variable "virtual_desktop_host_pool_maximum_sessions_allowed" {
  type        = number
  default     = 16
  description = "(Optional) A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the `type` of your Virtual Desktop Host Pool is `Pooled`."
}

variable "virtual_desktop_host_pool_name" {
  type        = string
  default     = "vdpool-avd-001"
  description = "The name of the AVD Host Pool"
}

variable "virtual_desktop_host_pool_start_vm_on_connect" {
  type        = bool
  default     = true
  description = "(Optional) Enables or disables the Start VM on Connection Feature. Defaults to `false`."
}

variable "virtual_desktop_host_pool_type" {
  type        = string
  default     = "Pooled"
  description = "The type of the AVD Host Pool. Valid values are 'Pooled' and 'Personal'."
}

variable "virtual_desktop_scaling_plan_name" {
  type        = string
  default     = "scp-avd-01"
  description = "The scaling plan for the AVD Host Pool."
}

variable "virtual_desktop_scaling_plan_time_zone" {
  type        = string
  default     = "GMT Standard Time"
  description = "Specifies the Time Zone which should be used by the Scaling Plan for time based events."
}

variable "virtual_desktop_workspace_name" {
  type        = string
  default     = "vdws-avd-001"
  description = "The name of the AVD Workspace"
}

variable "storage_accont_name" {
  description = "The name of the storage account"
  type        = string
}





