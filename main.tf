terraform {
    cloud {
    organization = "gk_guru8"

    workspaces {
      name = "func_app3"
    }
  }
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
  }
}

provider "azurerm" {
    features {}  
}

resource "random_integer" "random" {
    max = "9999"
  min = "0000"
  }

resource "random_string" "strandom" {
  length = 4    
}
resource "azurerm_resource_group" "rg" {
  name     = "rggkguru${random_integer.random.result}"
  location = "West Europe"

}

resource "azurerm_storage_account" "gksta" {
  name                     = "linuxfunctionappsta${random_integer.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "srvplan" {
  name                = "gkapp-service-plan${random_integer.random.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "lnxfapp" {
  name                = "gklinux-function-app${random_integer.random.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.gksta.name
  storage_account_access_key = azurerm_storage_account.gksta.primary_access_key
  service_plan_id            = azurerm_service_plan.srvplan.id

  site_config {}
}
