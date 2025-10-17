terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "region1_alter" {
  name     = var.resource_group_region1
  location = var.region1
}

resource "azurerm_resource_group" "region2_alter" {
  name     = var.resource_group_region2
  location = var.region2
}

resource "azurerm_virtual_network" "vnet_alter" {
  name                = "az104-vnet-region1-alter"
  address_space       = ["10.0.0.0/16"]
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1_alter.name
}

resource "azurerm_subnet" "subnet_alter" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.region1_alter.name
  virtual_network_name = azurerm_virtual_network.vnet_alter.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic_alter" {
  name                = "az104-nic-vm0-alter"
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1_alter.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_alter.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm_alter" {
  name           = "az104-10-vm0-alter"
  computer_name  = "az104vm0alter"
  location       = var.region1
  resource_group_name = azurerm_resource_group.region1_alter.name
  size           = "Standard_D2s_v3"
  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password
  network_interface_ids = [azurerm_network_interface.nic_alter.id]

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

resource "azurerm_recovery_services_vault" "rsv_region1_alter" {
  name                = var.vault_name_region1
  location            = var.region1
  resource_group_name = azurerm_resource_group.region1_alter.name
  sku                 = "Standard"
}

resource "azurerm_recovery_services_vault" "rsv_region2_alter" {
  name                = var.vault_name_region2
  location            = var.region2
  resource_group_name = azurerm_resource_group.region2_alter.name
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "backup_policy_alter" {
  name                = var.backup_policy_name
  resource_group_name = azurerm_resource_group.region1_alter.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv_region1_alter.name
  timezone            = var.timezone

  backup {
    frequency = "Daily"
    time      = "00:00"
  }

  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_protected_vm" "vm_backup_alter" {
  resource_group_name     = azurerm_resource_group.region1_alter.name
  recovery_vault_name     = azurerm_recovery_services_vault.rsv_region1_alter.name
  source_vm_id            = azurerm_windows_virtual_machine.vm_alter.id
  backup_policy_id        = azurerm_backup_policy_vm.backup_policy_alter.id
}

resource "azurerm_storage_account" "monitoring_alter" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.region1_alter.name
  location                 = var.region1
  account_tier             = "Standard"
  account_replication_type = "LRS"
}