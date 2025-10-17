variable "subscription_id" {
  type    = string
  default = "ede32291-affd-4373-add0-3fe062f1cd4a"
}

variable "region1" {
  type    = string
  default = "West US"
}

variable "region2" {
  type    = string
  default = "North Europe"
}

variable "resource_group_region1" {
  type    = string
  default = "az104-rg-region1-alter"
}

variable "resource_group_region2" {
  type    = string
  default = "az104-rg-region2-alter"
}

variable "vm_admin_username" {
  type    = string
  default = "localadmin"
}

variable "vm_admin_password" {
  type    = string
  default = "P@ssw0rd1234!"
}

variable "vault_name_region1" {
  type    = string
  default = "az104-rsv-region1-alter"
}

variable "vault_name_region2" {
  type    = string
  default = "az104-rsv-region2-alter"
}

variable "backup_policy_name" {
  type    = string
  default = "az104-backup-alter"
}

variable "timezone" {
  type    = string
  default = "UTC"
}

variable "storage_account_name" {
  type    = string
  default = "az104monitorlab10alter"
}