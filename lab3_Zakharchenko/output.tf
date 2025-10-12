output "disk_id" {
  value = azurerm_managed_disk.lab_disk.id
}

output "disk_name" {
  value = azurerm_managed_disk.lab_disk.name
}

output "disk_size" {
  value = azurerm_managed_disk.lab_disk.disk_size_gb
}