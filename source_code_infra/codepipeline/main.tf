module "aws-codepipeline" {
  source                     = "../modules/aws-codebuild-codepipeline"
  app_name                   = var.app_name
  region                     = var.region
  codebuild_project          = var.codebuild_project
  tr_environment_type        = var.tr_environment_type
  tr_resource_owner          = var.tr_resource_owner
  profile                    = var.profile
  infra_state                = var.infra_state
  ecs_state                  = var.ecs_state
  s3_state                   = var.s3_state
  account-id                 = var.account-id
  state_bucket_name          = var.state_bucket_name
  github_branch              = var.github_branch
  github_owner               = var.github_owner
  github_repo                = var.github_repo
  github_token               = var.github_token
  codepipeline_name          = var.codepipeline_name
}
