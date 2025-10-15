output "vmss_name" {
  description = "Назва масштабованого набору віртуальних машин"
  value       = azurerm_windows_virtual_machine_scale_set.vmss.name
}

output "vmss_instance_count" {
  description = "Кількість інстансів у VMSS"
  value       = azurerm_windows_virtual_machine_scale_set.vmss.instances
}