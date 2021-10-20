############################################################################
# Common tfvars
############################################################################
region              = "us-west-2"
app_name            = "fsc"
tr_environment_type = "DEVELOPMENT"
tr_resource_owner   = "vishnu Guntuka"

############################################################################
# s3 tfvars
############################################################################

bucket_name = "fsc-codepipeline-artifact-21"
profile = "shared"
infra_state = "dev-ecs-cluster"
state_bucket_name = "fsc-terraform-tfstate-2021"
account-id = "772765219897" 

############################################################################
# ecr tfvars
############################################################################

ecr_api = "core-api-app"
ecr_web = "core-api-web"