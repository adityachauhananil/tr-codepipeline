module "aws-s3" {
  source                     = "../modules/aws-s3-cross-account"
  app_name                   = var.app_name
  region                     = var.region
  tr_environment_type        = var.tr_environment_type
  tr_resource_owner          = var.tr_resource_owner
  bucket_name                = var.bucket_name
  profile                    = var.profile
  infra_state                = var.infra_state
  account-id                 = var.account-id
  state_bucket_name          = var.state_bucket_name
}


module "aws-ecr" {
  source                     = "../modules/aws-ecr"
  app_name                   = var.app_name
  region                     = var.region
  profile                    = var.profile
  infra_state                = var.infra_state
  account-id                 = var.account-id
  state_bucket_name          = var.state_bucket_name
  ecr_api                    = var.ecr_api
  ecr_web                    = var.ecr_web
}