variable "location" {
  type    = string
  default = "North Europe"
}

variable "resource_group_name" {
  type    = string
  default = "az104-rg11"
}

variable "vm_admin_username" {
  type    = string
  default = "localadmin"
}

variable "vm_admin_password" {
  type     = string
  sensitive = true
  default  = "SecurePassword123!"
}

variable "action_group_email" {
  type    = string
  default = "stanislav.zakharchenko.22@pnu.edu.ua"
}