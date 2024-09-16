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

variable "sku" {
  type        = string
}
