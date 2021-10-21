# Resource ECS cluster.
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tr_environment_type}-ecs_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Resource IAM role for ECS
resource "aws_iam_role" "fs-core-api-ecs-task-execution-role" {
  name = "fs-core-api-ecs-task-execution-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
            "ecs.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Environment = var.tr_environment_type
    Owner = var.tr_resource_owner
  }
}

# Resource IAM policy.
resource "aws_iam_policy" "ecs_policy_fsc" {
  name        = var.ecs_policy_fsc
  path        = "/"
  description = "ecs_policy_fsc"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "ec2:*",
          "ecs:*",
          "ecr:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "application-autoscaling:*",
          "logs:*",
          "tag:*",
          "resource-groups:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



resource "aws_iam_role_policy_attachment" "fsc_ecs_policy_attach" {
  role       = aws_iam_role.fs-core-api-ecs-task-execution-role.name
  policy_arn = aws_iam_policy.ecs_policy_fsc.arn
}


resource "aws_iam_role_policy_attachment" "fsc_ecs_policy_attach1" {
  role       = aws_iam_role.fs-core-api-ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Resource Cloudwatch.
resource "aws_cloudwatch_log_group" "ecs_logs_api" {
  name = "${var.container_prefix}-api-logs"
}

resource "aws_cloudwatch_log_group" "ecs_logs_web" {
  name = "${var.container_prefix}-web-logs"
}


data "aws_secretsmanager_secret" "coreapi" {
  arn = var.secret_store
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.coreapi.id
}


# Resource ECS task definitions.
resource "aws_ecs_task_definition" "app_web" {
  family = "fs-core-api-${var.tr_environment_type}-ecs-app"
  network_mode = "bridge"
  execution_role_arn = aws_iam_role.fs-core-api-ecs-task-execution-role.arn
  memory = var.memory
  cpu = var.cpu
  container_definitions = jsonencode([
  {
    name = "${var.container_prefix}-app",
    image = var.image_name_api,  # to be updated using code deploy
    essential = true,
    environment = [
      {
        name = "APP_NAME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["APP_NAME"]
      },
      {
        name = "APP_ENV",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["APP_ENV"]
      },
      {
        name = "APP_URL",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["APP_URL"]
      },
      {
        name = "APP_DEBUG",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["APP_DEBUG"]
      },
      {
        name = "LOG_CHANNEL",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["LOG_CHANNEL"]
      },
      {
        name = "BROADCAST_DRIVER",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["BROADCAST_DRIVER"]
      },
      {
        name = "QUEUE_CONNECTION",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["QUEUE_CONNECTION"]
      },
      {
        name = "CACHE_DRIVER",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["CACHE_DRIVER"]
      },
      {
        name = "CACHE_DEFAULT_TIME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["CACHE_DEFAULT_TIME"]
      },
      {
        name = "SESSION_DRIVER",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["SESSION_DRIVER"]
      },
      {
        name = "SESSION_LIFETIME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["SESSION_LIFETIME"]
      },
      {
        name = "DB_CONNECTION",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["DB_CONNECTION"]
      },
      {
        name = "DB_HOST",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["DB_HOST"]
      },
      {
        name = "DB_PORT",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["DB_PORT"]
      },
      {
        name = "DB_DATABASE",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["DB_DATABASE"]
      },
      {
        name = "DB_USERNAME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["DB_USERNAME"]
      },
      {
        name = "MAIL_ENCRYPTION",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_ENCRYPTION"]
      },
      {
        name = "MAIL_MAILER",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_MAILER"]
      },
      {
        name = "MAIL_HOST",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_HOST"]
      },
      {
        name = "MAIL_PORT",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_PORT"]
      },
      {
        name = "MAIL_FROM_ADDRESS",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_FROM_ADDRESS"]
      },
      {
        name = "MAIL_USERNAME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_USERNAME"]
      },
      {
        name = "MAIL_FROM_NAME",
        value = jsondecode(sensitive(data.aws_secretsmanager_secret_version.current.secret_string))["MAIL_FROM_NAME"]
      },
      {
        name = "DB_PASSWORD",
        "valueFrom": "arn:aws:ssm:${var.region}:${var.shared_account}:parameter/${var.tr_environment_type}/secrets/DATABASE_PASSWORD"
      },
      {
        name = "MAIL_PASSWORD",
        "valueFrom": "arn:aws:ssm:${var.region}:${var.shared_account}:parameter/${var.tr_environment_type}/secrets/MAIL_PASSWORD"
      }
     ],
    portMappings = [
      {
        containerPort = 9000
      },
      {
        containerPort = 22
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group = "${var.container_prefix}-api-logs",
        awslogs-region = var.region,
        awslogs-stream-prefix = "fs-core-api-${var.tr_environment_type}"
      }
    },
    memory = 256,
    WorkingDirectory = "/var/www"
  },
{
  name = "${var.container_prefix}-web",
  image = var.image_name_web,  # to be updated using code deploy
  essential = true,
  portMappings = [
      {
      containerPort = 80
      }
   ],
  logConfiguration = {
  logDriver = "awslogs",
  options = {
        awslogs-group = "${var.container_prefix}-web-logs",
        awslogs-region = var.region
        awslogs-stream-prefix = "${var.app_name}-core-api-${var.tr_environment_type}"
        }
  },
  memory = 256,
  VolumesFrom = [{
    SourceContainer  = "${var.container_prefix}-app"
  }]
  WorkingDirectory  = "/var/www"
  }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-core-api-${var.tr_environment_type}-ec2-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_web.arn
  desired_count   = 1
  iam_role        = aws_iam_role.fs-core-api-ecs-task-execution-role.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.fsc_target_group.arn
    container_name   = "${var.container_prefix}-web"
    container_port   = var.target_port
  }

}
