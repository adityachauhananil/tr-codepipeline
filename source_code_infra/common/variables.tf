variable "region" {
  description = "Region in which aws resources will be created"
  default     = "us-west-2"
}

variable "ecs-state" {
  description = "Statefile name for ECS"
  default     = "dev-ecs-cluster"
}

variable "codepipeline-state" {
  default = "shared-codepipeline"
}

variable "s3-state" {
  default = "shared-s3"
}

variable "state_bucket_name" {
  default = "fsc-terraform-tfstate-2021"
}

variable "profile" {
  default = "shared"
}