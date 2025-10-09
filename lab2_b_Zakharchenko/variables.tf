variable "resource_group_name" {
  description = "Name of the resource group to create"
  type        = string
  default     = "az104-rg2"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "cost_center_tag_name" {
  description = "The tag name to require/inherit"
  type        = string
  default     = "Cost Center"
}

variable "cost_center_value" {
  description = "The tag value to require/inherit"
  type        = string
  default     = "000"
}

variable "lock_name" {
  description = "Name of the deletion lock on the resource group"
  type        = string
  default     = "rg-lock"
}