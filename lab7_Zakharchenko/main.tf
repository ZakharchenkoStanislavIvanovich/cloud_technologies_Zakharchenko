terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
    versioning_enabled         = true
    change_feed_enabled        = false
    last_access_time_enabled   = false
    default_service_version    = "2020-06-12"
  }

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = ["46.175.142.138"]
  }

  tags = {
    lab = "az104-lab07"
  }
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

resource "azurerm_storage_container_immutability_policy" "policy" {
  storage_container_resource_manager_id = azurerm_storage_container.data.resource_manager_id
  immutability_period_in_days           = 180
}

resource "azurerm_management_lock" "immutability_lock" {
  name       = "immutability-lock"
  scope      = azurerm_storage_container_immutability_policy.policy.id
  lock_level = "CanNotDelete"
  notes      = "Required for immutable blob policy"
}

resource "azurerm_storage_account_static_website" "static_web" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = file("${path.module}/index.html")
}

resource "azurerm_storage_blob" "error404" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = file("${path.module}/404.html")
}