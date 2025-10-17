provider "azurerm" {
  features {}
  subscription_id = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "az104-vnet11"
  address_space       = ["10.11.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.11.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "az104-nic11"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "az104-vm11"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2s"
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

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

resource "azurerm_monitor_action_group" "ops_team" {
  name                = "alert-operations-team"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "AlertOpsTeam"

  email_receiver {
    name          = "VMWasDeleted"
    email_address = var.action_group_email
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_delete_alert" {
  name                = "vm-delete-alert"
  location            = "global"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_resource_group.rg.id]
  description         = "A VM in your resource group was deleted"
  enabled             = true

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.Compute/virtualMachines/delete"
    level          = "Informational"
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops_team.id
  }
}