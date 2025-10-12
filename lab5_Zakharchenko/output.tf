output "core_vm_private_ip" {
  value = azurerm_network_interface.core_nic.private_ip_address
}

output "manufacturing_vm_private_ip" {
  value = azurerm_network_interface.manufacturing_nic.private_ip_address
}

output "route_table_id" {
  value = azurerm_route_table.core_rt.id
}