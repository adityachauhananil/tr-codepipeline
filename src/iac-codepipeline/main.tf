data "aws_caller_identity" "current" {}

# Github local variable.
locals {
  github_token  = var.github_token
  github_owner  = var.github_owner
  github_repo   = var.github_repo
  github_branch = var.github_branch
}

# Data terraform state blocks.
# data "terraform_remote_state" "infra" {
#   backend = "s3"
#   config = {
#     bucket  = var.state_bucket_name
#     key     = "${var.infra_state}.tfstate"
#     region  = "us-west-2"
#     profile = var.profile
#   }
# }

# data "terraform_remote_state" "ecs" {
#   backend = "s3"
#   config = {
#     bucket  = var.state_bucket_name
#     key     = "${var.ecs_state}.tfstate"
#     region  = "us-west-2"
#     profile = var.profile
#   }
# }


# data "terraform_remote_state" "s3" {
#   backend = "s3"
#   config = {
#     bucket  = var.state_bucket_name
#     key     = "${var.s3_state}.tfstate"
#     region  = "us-west-2"
#     profile = var.profile
#   }
# }

##bucket to store artifacts 
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "iac-pipeline-artifacts-2021"
  acl    = "private"
}

# Resource Codepipeline.
resource "aws_codepipeline" "codepipeline" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    # encryption_key {
    #   id   = aws_kms_alias.s3encryption_alias.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken = "${local.github_token}"
        Owner      = "${local.github_owner}"
        Repo       = "${local.github_repo}"
        Branch     = "${local.github_branch}"
      }
    }
  }

  stage {
    name = "dev"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_build.name
      }
    }
  }
  # stage {
  #   name = "Deploy"

  #   action {
  #     name            = "Deploy"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "ECS"
  #     input_artifacts = ["build_output"]
  #     version         = "1"

  #     role_arn = data.terraform_remote_state.ecs.outputs.cross_account_role_arn
  #     configuration = {
  #       ClusterName = data.terraform_remote_state.ecs.outputs.ecs_cluster_name
  #       ServiceName = data.terraform_remote_state.ecs.outputs.ecs_cluster_servicename
  #       FileName    = "imagedefinitions.json"
  #     }
  #   }
  # }
}


# Resource Codepipeline role.
resource "aws_iam_role" "codepipeline_role" {
  name = var.codepipeline-role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com",
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    }
    ]
  }
EOF
}

# Resource Codepipeline Policy.
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Sid": "IamPassRolePolicy",
      "Effect": "Allow",
      "Action": [
          "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
        ],
      "Resource":  "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
    "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
    ],
    "Resource": "*",
    "Effect": "Allow"
    },
    {
    "Action": [
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:ListTasks",
        "ecs:RegisterTaskDefinition",
        "ecs:UpdateService"
    ],
    "Resource": "*",
    "Effect": "Allow"
    },
    {
    "Action": [
        "codestar-connections:UseConnection"
    ],
    "Resource": "*",
    "Effect": "Allow"
    },
        {
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:Encrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
    {
      "Action": "sts:*",
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Resource KMS Key.
# resource "aws_kms_key" "s3encryption" {
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Id": "key-default-1",
#   "Statement": [{
#     "Sid": "Enable IAM User Permissions",
#     "Effect": "Allow",
#     "Principal": {
#       "AWS": [
#         "*",
#         "arn:aws:iam::${var.account-id}:root",
#         "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
#       ]
#     },
#     "Action": "kms:*",
#     "Resource": "*"
#   }]
# }
# EOF
# }

# Resource Encryption alias.
# resource "aws_kms_alias" "s3encryption_alias" {
#   name          = var.aws_kms_alias
#   target_key_id = aws_kms_key.s3encryption.key_id
# }