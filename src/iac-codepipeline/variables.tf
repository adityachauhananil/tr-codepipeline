variable "approve_comment" {
  description = "Approval gate"
  default = "Approve"
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

variable "codebuild_project_plan" {
  description = "Project Name"
}

variable "codebuild_project_apply" {
  description = "Project Name"
}
variable "github_token" {
  description = "github token for connection"
}

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

variable "s3_state" {
  description = "Statefile for ecs for cross-account role."
}

variable "ecs_state" {
  description = "Statefile for ecs for cross-account role."
}

variable "state_bucket_name" {
  description = "Bucket name for state management."
}

variable "account-id" {
  description = "Account id for cross account."
}

variable "codepipeline_name" {
  description = "Codepipeline Name"
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

variable "code_build_role" {
  description = "Role name for codebuild service"
  default     = "code_build_role"
}

variable "codepipeline-role" {
  description = "Role name for codepipeline service"
  default     = "codepipeline-role"
}

variable "aws_kms_alias" {
  description = "Alias for S3 encruption using KMS."
  default     = "alias/s3encrypt-dev"
}