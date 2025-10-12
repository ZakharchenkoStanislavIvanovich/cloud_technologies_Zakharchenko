provider "azurerm" {
  features {}

  subscription_id = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

resource "azurerm_resource_group" "lab_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_managed_disk" "lab_disk" {
  name                 = var.disk_name
  location             = var.location
  resource_group_name  = azurerm_resource_group.lab_rg.name
  storage_account_type = var.sku
  disk_size_gb         = var.disk_size_gb
  create_option        = "Empty"
}