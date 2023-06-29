terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "Teste-tf"
      storage_account_name = "tfstated3lip"
      container_name       = "tfstate"
      key                  = "terraformBackendKeyAle"
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Teste-tf" {
  name     = "Teste-tf"
  location = "brazilsouth"
}
