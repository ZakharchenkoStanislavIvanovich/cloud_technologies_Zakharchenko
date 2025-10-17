terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

provider "azapi" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_container_app_environment" "env" {
  name                = var.environment_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azapi_resource" "container_app" {
  type      = "Microsoft.App/containerApps@2023-05-01"
  name      = var.container_app_name
  location  = var.location
  parent_id = azurerm_resource_group.rg.id

  body = {
    properties = {
      environmentId = azurerm_container_app_environment.env.id
      configuration = {
        ingress = {
          external = true
          targetPort = 80
          traffic = [
            {
              latestRevision = true
              weight = 100
            }
          ]
        }
      }
      template = {
        containers = [
          {
            name  = "hello"
            image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
            resources = {
              cpu    = 0.25
              memory = "0.5Gi"
            }
          }
        ]
      }
    }
  }
}