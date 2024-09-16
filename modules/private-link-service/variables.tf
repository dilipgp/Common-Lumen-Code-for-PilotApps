variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the Private Link Service should exist"
}

variable "private_link_services_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - Private Link Service
# -
variable "private_link_services" {
  type = map(object({
    name                           = string # (Required) Specifies the name of this Private Link Service.
    location                       = string # (Required) Specifies the location of this Private Link Service.
    frontend_ip_config_name        = string # (Required) Frontend IP Configuration name from a Standard Load Balancer, where traffic from the Private Link Service should be routed    
    pls_resource_group             = string # (Required) Specifies the Resource Group name of this Private Link Service.
    subnet_name                    = string # (Required) Specifies the name of the Subnet which should be used for the Private Link Service.
    vnet_name                      = string # (Required) Specifies the name of the Virtual Network which should be used for the Private Link Service.
    networking_resource_group      = string # (Required) Specifies the Resource Group of the Subnet which should be used for the Private Link Service.
    loadbalancer_name              = string
    lb_resource_group              = string
    auto_approval_subscription_ids = list(string) # (Optional) A list of Subscription UUID/GUID's that will be automatically be able to use this Private Link Service.
    visibility_subscription_ids    = list(string) # (Optional) A list of Subscription UUID/GUID's that will be able to see this Private Link Service.
    enable_proxy_protocol          = bool         # (Optional) Should the Private Link Service support the Proxy Protocol? Defaults to false.
    private_ip_address             = string       # (Optional) Specifies a Private Static IP Address for this IP Configuration.
    private_ip_address_version     = string       # (Optional) The version of the IP Protocol which should be used

  }))
  description = "Map containing private link services"
  default     = {}
}

