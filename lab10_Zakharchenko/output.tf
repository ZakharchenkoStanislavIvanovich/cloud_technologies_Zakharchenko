output "vm_id" {
  value = azurerm_windows_virtual_machine.vm_alter.id
}

output "vault_region1_name" {
  value = azurerm_recovery_services_vault.rsv_region1_alter.name
}

output "vault_region2_name" {
  value = azurerm_recovery_services_vault.rsv_region2_alter.name
}