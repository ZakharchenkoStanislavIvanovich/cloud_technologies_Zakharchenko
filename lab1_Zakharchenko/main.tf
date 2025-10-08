terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}

provider "azuread" {}

data "azuread_client_config" "current" {}

resource "azuread_user" "local_user" {
  user_principal_name = var.local_user_upn
  display_name        = var.local_user_display_name
  password            = var.local_user_password
  account_enabled     = true
  job_title           = var.local_user_job_title
  department          = var.local_user_department
  usage_location      = var.local_user_location
}

resource "azuread_invitation" "external_user_invite" {
  user_email_address = var.external_user_email
  redirect_url       = "https://portal.azure.com"
  user_display_name  = var.external_user_display_name

  message {
    body = var.external_user_message
  }
}

resource "azuread_group" "lab_admins" {
  display_name     = var.group_name
  description      = var.group_description
  security_enabled = true
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_group_member" "local_member" {
  group_object_id  = azuread_group.lab_admins.id
  member_object_id = azuread_user.local_user.id
}