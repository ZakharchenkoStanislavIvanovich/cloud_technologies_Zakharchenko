output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "container_name" {
  value = azurerm_storage_container.data.name
}

output "static_website_url" {
  value = azurerm_storage_account.storage.primary_web_endpoint
}