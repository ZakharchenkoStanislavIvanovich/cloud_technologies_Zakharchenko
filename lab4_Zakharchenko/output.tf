output "core_vnet_id" {
  value = azurerm_virtual_network.core.id
}

output "shared_services_subnet_id" {
  value = azurerm_subnet.shared_services.id
}

output "database_subnet_id" {
  value = azurerm_subnet.database.id
}

output "asg_web_id" {
  value = azurerm_application_security_group.asg_web.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "public_dns_zone" {
  value = azurerm_dns_zone.public_dns.name
}

output "private_dns_zone" {
  value = azurerm_private_dns_zone.private_dns.name
}