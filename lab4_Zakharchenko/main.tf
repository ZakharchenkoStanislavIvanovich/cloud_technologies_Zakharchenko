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
  subscription_id = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

resource "azurerm_virtual_network" "core" {
  name                = "CoreServicesVnet"
  address_space       = ["10.20.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "shared_services" {
  name                 = "SharedServicesSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.10.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "DatabaseSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.20.0/24"]
}

resource "azurerm_application_security_group" "asg_web" {
  name                = "asg-web"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "myNSGSecure"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.shared_services.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "allow_asg" {
  name                                     = "AllowASG"
  priority                                 = 100
  direction                                = "Inbound"
  access                                   = "Allow"
  protocol                                 = "Tcp"
  source_port_range                        = "*"
  destination_port_ranges                  = ["80", "443"]
  source_application_security_group_ids    = [azurerm_application_security_group.asg_web.id]
  destination_address_prefix               = "*"
  network_security_group_name              = azurerm_network_security_group.nsg.name
  resource_group_name                      = var.resource_group_name
}

resource "azurerm_network_security_rule" "deny_internet" {
  name                        = "DenyInternetOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_dns_zone" "public_dns" {
  name                = "yellowlab4.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "public_www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.public_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 1
  records             = ["10.1.1.4"]
}

resource "azurerm_private_dns_zone" "private_dns" {
  name                = "private.contoso.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "manufacturing-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.manufacturing_vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_a_record" "sensor_vm" {
  name                = "sensorvm"
  zone_name           = azurerm_private_dns_zone.private_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 1
  records             = ["10.1.1.4"]
}