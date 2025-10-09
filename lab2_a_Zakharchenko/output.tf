output "management_group_id" {
  description = "ID створеної Management Group"
  value       = azurerm_management_group.mg.id
}

output "vm_contributor_assignment_id" {
  description = "ID призначення VM Contributor"
  value       = azurerm_role_assignment.vm_contributor_assignment.id
}

output "custom_role_definition_id" {
  description = "ID створеної кастомної ролі"
  value       = azurerm_role_definition.custom_support.role_definition_resource_id
}

output "custom_support_assignment_id" {
  description = "ID призначення кастомної ролі"
  value       = azurerm_role_assignment.custom_support_assignment.id
}