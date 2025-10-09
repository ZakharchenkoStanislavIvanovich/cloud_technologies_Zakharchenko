terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    (var.cost_center_tag_name) = var.cost_center_value
  }
}

data "azurerm_policy_definition" "require_tag" {
  display_name = "Require a tag and its value on resources"
}

data "azurerm_policy_definition" "inherit_tag" {
  display_name = "Inherit a tag from the resource group if missing"
}

resource "azurerm_resource_group_policy_assignment" "require_tag" {
  name                 = "require-cost-center-tag"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.require_tag.id
  enforce              = true

  parameters = <<JSON
{
  "tagName": {
    "value": "${var.cost_center_tag_name}"
  },
  "tagValue": {
    "value": "${var.cost_center_value}"
  }
}
JSON
}

resource "azurerm_resource_group_policy_assignment" "inherit_tag" {
  name                 = "inherit-cost-center-tag"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.inherit_tag.id
  enforce              = true
  location             = azurerm_resource_group.rg.location

  parameters = <<JSON
{
  "tagName": {
    "value": "${var.cost_center_tag_name}"
  }
}
JSON

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_user_assigned_identity" "mi" {
  name                = "example-mi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "mi_owner" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

resource "azurerm_management_lock" "rg_lock" {
  name       = var.lock_name
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
}