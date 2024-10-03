
locals {
  accountvars                    = yamldecode(file("accountvars.yml"))

  merged_vars = merge(
    local.accountvars,
    {
      tenant_id                        = "${local.accountvars.tenant_id}"
      subscription_id                  = "${local.accountvars.subscription_id}"
      tf_remote_state_resource_group   = "${local.accountvars.tf_remote_state_resource_group}"
      tf_remote_state_storage_account  = "${local.accountvars.tf_remote_state_storage_account}"
      tf_remote_state_container_name   = "${local.accountvars.tf_remote_state_container_name}"
      tf_app_name                      = "${local.accountvars.tf_app_name}"
      env                              = "${local.accountvars.env}"
    }
  )
}

generate "provider" {
  path      = "azurerm_provider.tf"
  if_exists = "skip"
  contents  = <<EOF
  terraform {
    required_version = ">= 1.3.0"
    required_providers {
      azapi = {
        source  = "Azure/azapi"
        version = ">= 1.4.0, < 2.0"
      }
      azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 3.86.0, <4.0"
      }
      local = {
        source  = "hashicorp/local"
        version = ">=2.4.1, < 3.0"
      }
      modtm = {
        source  = "Azure/modtm"
        version = ">= 0.3, < 1.0"
      }
      null = {
        source  = "hashicorp/null"
        version = ">= 3.0"
      }
      random = {
        source  = "hashicorp/random"
        version = ">= 3.5.0"
      }
    }
  }
  provider "azurerm" {
    skip_provider_registration = false
    subscription_id            = "${local.merged_vars.subscription_id}"
    features {}
  }
  EOF
}

remote_state {
  backend = "azurerm"
  config = {
    subscription_id      = "${local.merged_vars.subscription_id}"
    key                  = "${path_relative_to_include()}_${local.merged_vars.env}_${local.merged_vars.tf_app_name}.tfstate"
    resource_group_name  = "${local.merged_vars.tf_remote_state_resource_group}"
    storage_account_name = "${local.merged_vars.tf_remote_state_storage_account}"
    container_name       = "${local.merged_vars.tf_remote_state_container_name}"
    tenant_id            = "${local.merged_vars.tenant_id}"
  }

  # Configure Terragrunt to automatically generate a backend.tf file that configures the remote state backend
  # This eliminates the need to have an empty backend block in the module
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = local.merged_vars