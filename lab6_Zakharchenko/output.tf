output "vm_private_ips" {
  value = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}