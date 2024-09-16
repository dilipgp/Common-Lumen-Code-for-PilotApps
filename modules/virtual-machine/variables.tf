variable "name" {
  description = "The name of the resource."
  type        = string
}

variable "location" {
  description = "The location/region where the resource will be deployed."
  type        = string
}

variable "network_interfaces" {
  description = "A map of network interfaces associated with the resource. Each key is a unique identifier, and the value is an object with the interface properties."
  type = map(object({
    name              = string
    ip_configurations = map(object({
      name                          = string
      private_ip_subnet_resource_id = string
      private_ip_address            = optional(string)  # Optional if not always required
      public_ip_address             = optional(string)  # Optional if not always required
    }))
    primary = optional(bool)  # Optional, based on your usage
  }))
}
variable "zone" {
  description = "The availability zone where the resource should be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the resource."
  type        = string
}
