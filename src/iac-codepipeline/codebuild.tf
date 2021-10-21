# Resource IAM role.
resource "aws_iam_role" "code_build_role" {
  name = var.code_build_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Resource Iam role policy
resource "aws_iam_role_policy" "code_build_policy" {
  role = aws_iam_role.code_build_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
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
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
    {
            "Action": [
                "ssm:ListCommands",
                "ssm:ListDocumentVersions",
                "ssm:ListDocumentMetadataHistory",
                "ssm:DescribeMaintenanceWindowSchedule",
                "ssm:DescribeInstancePatches",
                "ssm:ListInstanceAssociations",
                "ssm:GetParameter",
                "ssm:GetMaintenanceWindowExecutionTaskInvocation",
                "ssm:DescribeAutomationExecutions",
                "ssm:GetMaintenanceWindowTask",
                "ssm:DescribeMaintenanceWindowExecutionTaskInvocations",
                "ssm:DescribeAutomationStepExecutions",
                "ssm:ListOpsMetadata",
                "ssm:DescribeParameters",
                "ssm:ListResourceDataSync",
                "ssm:ListDocuments",
                "ssm:DescribeMaintenanceWindowsForTarget",
                "ssm:ListComplianceItems",
                "ssm:GetConnectionStatus",
                "ssm:GetMaintenanceWindowExecutionTask",
                "ssm:GetOpsItem",
                "ssm:GetMaintenanceWindowExecution",
                "ssm:ListResourceComplianceSummaries",
                "ssm:GetParameters",
                "ssm:GetOpsMetadata",
                "ssm:ListOpsItemRelatedItems",
                "ssm:DescribeOpsItems",
                "ssm:DescribeMaintenanceWindows",
                "ssm:DescribeEffectivePatchesForPatchBaseline",
                "ssm:GetServiceSetting",
                "ssm:DescribeAssociationExecutions",
                "ssm:DescribeDocumentPermission",
                "ssm:ListCommandInvocations",
                "ssm:GetAutomationExecution",
                "ssm:DescribePatchGroups",
                "ssm:GetDefaultPatchBaseline",
                "ssm:DescribeDocument",
                "ssm:GetDocument"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
  ]
}
POLICY
}

# Resource for Codebuild.
resource "aws_codebuild_project" "code_build" {
  name          = var.codebuild_project
  description   = "codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.code_build_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  # cache {
  #   type     = "S3"
  #   location = data.terraform_remote_state.s3.outputs.s3_bucket_id
  # }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0" # "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    # environment_variable {
    #   name  = "REPOSITORY_URI"
    #   value = data.terraform_remote_state.s3.outputs.aws_web_url
    # }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    # s3_logs {
    #   status   = "ENABLED"
    #   location = "${data.terraform_remote_state.s3.outputs.s3_bucket_id}/build-log"
    # }
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 0
    buildspec       = "buildspec-dev.yml"
  }
  source_version = var.github_branch

  tags = {
    Environment = var.tr_environment_type
    Owner       = var.tr_resource_owner
  }
}
