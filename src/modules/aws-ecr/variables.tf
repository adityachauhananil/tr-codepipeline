variable "region" {
  description = "Default region"
}

variable "app_name" {
  description = "Name of the app as a tag prefix"
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

variable "ecr_api" {
  description = "ECR repository for API"
}

variable "ecr_web" {
  description = "ECR repository for WEB"
}