variable "private_endpoints" {
  type = map(object({
    name                           = string
    private_connection_resource_id = string
    is_manual_connection           = optional(bool)
    subresource_names              = list(string)
    request_message                = optional(string)
    private_dns_zone_group_name    = optional(string)
    private_dns_zone_ids           = optional(list(string))
  }))
  description = "Private Endpoints for the supported resources"
  default     = {}
}

# for 'subresource_names' https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource

variable "tags" {
  type    = map(any)
  default = {}
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "subscription_id" {
  type    = string
  default = null
}

variable "virtual_network_rg" {
  type    = string
  default = null
}

variable "virtual_network_name" {
  type    = string
  default = null
}

variable "pe_subnet_name" {
  type    = string
  default = null
}