terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "azurerm_management_group" "mg" {
  name         = var.management_group_id
  display_name = var.management_group_display_name
}

resource "azuread_group" "helpdesk" {
  display_name     = var.helpdesk_group_name
  security_enabled = true
}

data "azurerm_role_definition" "vm_contributor" {
  name  = "Virtual Machine Contributor"
  scope = azurerm_management_group.mg.id
}

resource "azurerm_role_assignment" "vm_contributor_assignment" {
  scope              = azurerm_management_group.mg.id
  role_definition_id = data.azurerm_role_definition.vm_contributor.id
  principal_id       = azuread_group.helpdesk.id
}

resource "azurerm_role_definition" "custom_support" {
  name        = var.custom_role_name
  scope       = azurerm_management_group.mg.id
  description = var.custom_role_description

  permissions {
    actions     = ["Microsoft.Support/*"]
    not_actions = ["Microsoft.Support/register/action"]
  }

  assignable_scopes = [
    azurerm_management_group.mg.id
  ]
}

resource "azurerm_role_assignment" "custom_support_assignment" {
  scope              = azurerm_management_group.mg.id
  role_definition_id = azurerm_role_definition.custom_support.role_definition_resource_id
  principal_id       = azuread_group.helpdesk.id
}