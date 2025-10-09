variable "management_group_id" {
  description = "Унікальний ідентифікатор management group"
  type        = string
  default     = "az104-mg1"
}

variable "management_group_display_name" {
  description = "Відображуване ім'я management group"
  type        = string
  default     = "az104-mg1"
}

variable "helpdesk_group_name" {
  description = "Назва групи Help Desk у Microsoft Entra ID"
  type        = string
  default     = "Help Desk"
}

variable "custom_role_name" {
  description = "Ім'я кастомної RBAC ролі"
  type        = string
  default     = "Custom Support Request"
}

variable "custom_role_description" {
  description = "Опис кастомної RBAC ролі"
  type        = string
  default     = "A custom contributor role for support requests."
}