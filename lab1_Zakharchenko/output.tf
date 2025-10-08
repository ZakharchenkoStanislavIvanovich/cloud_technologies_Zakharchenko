output "local_user_id" {
  value = azuread_user.local_user.id
}

output "group_id" {
  value = azuread_group.lab_admins.id
}

output "group_members" {
  value = [
    azuread_group_member.local_member.member_object_id
  ]
}