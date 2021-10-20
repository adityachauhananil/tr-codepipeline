# Data resource for remote state.
data "terraform_remote_state" "infra" {
  backend = "s3"
  config  = {
    bucket   = var.state_bucket_name
    key      = "${var.infra_state}.tfstate"
    region   = "us-west-2"
    profile  = var.profile
  }
}


# Resource ECR repository.
resource "aws_ecr_repository" "core_app_api" {
  name                 = var.ecr_api
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "core_app_web" {
  name                 = var.ecr_web
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Resource ECR policy.
resource "aws_ecr_repository_policy" "core_app_web_policy" {
  repository = aws_ecr_repository.core_app_web.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.terraform_remote_state.infra.outputs.fs-core-api-ecs-task-execution-role}"
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    },
    {
      "Sid": "AllowAll",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.terraform_remote_state.infra.outputs.fs-core-api-ecs-task-execution-role}"
      },
      "Action": "ecr:*"
    }
  ]
}
EOF
}

resource "aws_ecr_repository_policy" "core_app_api_policy" {
  repository = aws_ecr_repository.core_app_api.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.terraform_remote_state.infra.outputs.fs-core-api-ecs-task-execution-role}"
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    },
    {
      "Sid": "AllowAll",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.terraform_remote_state.infra.outputs.fs-core-api-ecs-task-execution-role}"
      },
      "Action": "ecr:*"
    }
  ]
}
EOF
}