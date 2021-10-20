############################################################################
# Common tfvars
############################################################################
region              = "us-west-2"
app_name            = "fsc"
tr_environment_type = "dev"
tr_resource_owner   = "vishnu Guntuka"

############################################################################
# statefile tfvars
############################################################################

profile = "shared"
infra_state = "infra-setup"
ecs_state = "dev-ecs-cluster"
s3_state = "shared-s3"
state_bucket_name = "fsc-terraform-tfstate-2021"
account-id = "772765219897"

github_token  = "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"
github_owner  = "FieldSafe"
github_repo   = "core.api"
github_branch = "develop_pipeline_test"

codepipeline_name = "fsc-Codepipeline"
codebuild_project = "fsc-codebuild"