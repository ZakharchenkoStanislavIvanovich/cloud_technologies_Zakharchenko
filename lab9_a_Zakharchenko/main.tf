terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "az104-rg9"
  location = var.location
}

resource "azurerm_app_service_plan" "plan" {
  name                = "webapp-plan-yellow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_app_service_plan.plan.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
    always_on = false
  }
}

resource "null_resource" "wait_for_webapp" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [azurerm_linux_web_app.webapp]
}