terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "tfstatestorageaccountrg"
    storage_account_name = "tfstatestorage0627"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
