terraform {
  backend "azurerm" {
    resource_group_name  = "test-lumen-rg5"
    storage_account_name = "tfbackendstrgacct843"
    container_name       = "tfbackendcontainer11"
    key                  = "terraform.tfstate"
  }
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.86.0, <4.0" #">= 3.7.0, < 4.0.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.4.0, < 2.0" #"~> 1.13"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.1, < 3.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = ">= 0.3, < 1.0"
    }
  }

}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  storage_use_azuread = true
}

provider "azapi" {
  use_oidc = true
}