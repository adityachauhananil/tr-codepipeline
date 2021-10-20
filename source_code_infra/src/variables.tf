variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "region" {
  description = "Region for bucket deployemnt."
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

variable "github_branch" {
  description = "Github branch for your application"
}

variable "github_owner" {
  description = "Github repository owner for your application"
}

variable "github_repo" {
  description = "Repo name"
}

variable "github_token" {
  description = "github token for connection"
}

variable "codepipeline_name" {
  description = "Codepipeline Name"
}

variable "s3_state" {
  description = "Statefile for ecs for cross-account role."
}

variable "ecs_state" {
  description = "Statefile for ecs for cross-account role."
}

variable "codebuild_project" {
  description = "Project Name"
}