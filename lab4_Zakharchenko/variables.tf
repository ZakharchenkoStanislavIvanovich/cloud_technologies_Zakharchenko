variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "az104-rg4"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "manufacturing_vnet_id" {
  description = "ID of the ManufacturingVnet created via template"
  type        = string
}