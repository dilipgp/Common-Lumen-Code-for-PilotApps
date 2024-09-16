variable "name" {
    description = "Rg name"
    type = string
  
}

variable "location" {
  description = "The Azure location where the resources will be created"
  type        = string
  default     = "East US"
}
