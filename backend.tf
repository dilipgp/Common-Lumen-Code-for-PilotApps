terraform {
  backend "azurerm" {
    resource_group_name  = "Github"
    storage_account_name = "devopslumen"
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"

  }
}

