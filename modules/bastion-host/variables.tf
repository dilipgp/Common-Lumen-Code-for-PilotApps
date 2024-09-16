variable "name" {
  type        = string
  description = "The name of the resource."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "location" {
  type        = string
}

variable "ip_configuration" {
  description = "IP Configuration for the network interface."
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
}