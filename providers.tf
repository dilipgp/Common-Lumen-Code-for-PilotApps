terraform {
  required_version = ">= 1.6.6, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.1, < 4.0.0"
    }
    virtual = {
      source = "hashicorp/virtual"
      version = ">= 0.0.0"
    }

    resource = {
      source = "hashicorp/resource"
      version = ">= 0.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1, < 4.0.0"
    }
    
  }
}
    # azapi = {
    #   source  = "Azure/azapi"
    #   version = ">= 1.4.0, < 2.0" #"~> 1.13"
    # }

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

