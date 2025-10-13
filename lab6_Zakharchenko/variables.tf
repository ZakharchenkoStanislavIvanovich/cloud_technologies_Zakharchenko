variable "location" {
  default = "West US"
}

variable "resource_group_name" {
  default = "az104-rg6"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  description = "Password for VM admin"
  type        = string
  sensitive   = true
}