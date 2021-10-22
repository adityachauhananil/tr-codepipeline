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

profile = "default"
infra_state = "infra-setup"
ecs_state = "dev-ecs-cluster"
s3_state = "shared-s3"
state_bucket_name = "iac-pipeline-test-2021"
# account-id = "772765219897"
account-id = "265047468780"

github_token  = "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"
github_owner  = "adityachauhananil"
github_repo   = "tr-codepipeline"
github_branch = "dev"

codepipeline_name = "iac-Codepipeline"
codebuild_project_plan = "iac-codebuild-plan"
codebuild_project_apply = "iac-codebuild-apply"
codestar_connection = "arn:aws:codestar-connections:us-west-2:265047468780:connection/62956e10-5968-4a16-a21c-2be404943157"