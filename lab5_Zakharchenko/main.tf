terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "Central US"
}

resource "azurerm_virtual_network" "core" {
  name                = "CoreServicesVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "core_subnet" {
  name                 = "Core"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "perimeter" {
  name                 = "perimeter"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "manufacturing" {
  name                = "ManufacturingVnet"
  address_space       = ["172.16.0.0/16"]
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "manufacturing_subnet" {
  name                 = "Manufacturing"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.manufacturing.name
  address_prefixes     = ["172.16.0.0/24"]
}

resource "azurerm_network_interface" "core_nic" {
  name                = "CoreNIC"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_subnet.core_subnet]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.core_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "manufacturing_nic" {
  name                = "ManufacturingNIC"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_subnet.manufacturing_subnet]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.manufacturing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "core_vm" {
  name                = "CoreServicesVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "Central US"
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.core_nic.id]

  depends_on = [azurerm_network_interface.core_nic]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "manufacturing_vm" {
  name                = "ManufacturingVM"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "Central US"
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.manufacturing_nic.id]

  depends_on = [azurerm_network_interface.manufacturing_nic]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_network_peering" "core_to_manufacturing" {
  name                      = "CoreToManufacturing"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.core.name
  remote_virtual_network_id = azurerm_virtual_network.manufacturing.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [azurerm_virtual_network.core, azurerm_virtual_network.manufacturing]
}

resource "azurerm_virtual_network_peering" "manufacturing_to_core" {
  name                      = "ManufacturingToCore"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.manufacturing.name
  remote_virtual_network_id = azurerm_virtual_network.core.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [azurerm_virtual_network.core, azurerm_virtual_network.manufacturing]
}

resource "azurerm_route_table" "core_rt" {
  name                = "rt-CoreServices"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "perimeter_to_core" {
  name                    = "PerimetertoCore"
  resource_group_name     = azurerm_resource_group.rg.name
  route_table_name        = azurerm_route_table.core_rt.name
  address_prefix          = "10.0.0.0/16"
  next_hop_type           = "VirtualAppliance"
  next_hop_in_ip_address  = "10.0.1.7"

  depends_on = [azurerm_route_table.core_rt]
}

resource "azurerm_subnet_route_table_association" "core_assoc" {
  subnet_id      = azurerm_subnet.core_subnet.id
  route_table_id = azurerm_route_table.core_rt.id

  depends_on = [azurerm_subnet.core_subnet, azurerm_route_table.core_rt]
}