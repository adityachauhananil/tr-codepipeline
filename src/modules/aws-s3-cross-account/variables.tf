variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "region" {
  description = "Region for bucket deployemnt."
}

variable "bucket_name" {
  description = "value"
}

variable "profile" {
  description = "Profile for state management"
}

variable "infra_state" {
  description = "Statefile for ecs for cross-account role."
}

variable "state_bucket_name" {
  description = "Bucket name for state management."
}

variable "account-id" {
  description = "Account id for cross account."
}

variable "tr_environment_type" {
  description = "environment type"
}

variable "tr_resource_owner" {
  description = "Resource owner"
}


locals {
  prefix = var.app_name
  common_tags = {
    "tr:environment-type" = var.tr_environment_type
    "tr:resource-owner"   = var.tr_resource_owner
  }
}