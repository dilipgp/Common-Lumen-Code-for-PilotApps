terraform {
  required_version = ">= 1.6.6, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.1, < 4.0.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "Github"
    storage_account_name = "devopslumen01"
    container_name       = "tfstatefile"
    key                  = "dev.tfstate"

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

