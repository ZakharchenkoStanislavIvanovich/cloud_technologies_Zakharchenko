output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "require_tag_assignment_id" {
  value = azurerm_resource_group_policy_assignment.require_tag.id
}

output "inherit_tag_assignment_id" {
  value = azurerm_resource_group_policy_assignment.inherit_tag.id
}

output "user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.mi.id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.mi_owner.id
}

output "lock_id" {
  value = azurerm_management_lock.rg_lock.id
}