variable "admin_username" {
  description = "Ім’я адміністратора для VMSS"
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Пароль адміністратора для VMSS"
  type        = string
  sensitive   = true
  default     = "TempPass123!Lab8"
}