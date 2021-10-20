output "cross_account_role" {
  value = module.aws-iam-cross-account.cross_account_role
}

output "cross_account_role_arn" {
  value = module.aws-iam-cross-account.cross_account_role_arn
}

output "fs-core-api-ecs-task-execution-role" {
  value = module.aws-ecs-setup.fs-core-api-ecs-task-execution-role
}

output "ecs_cluster_name" {
  value = module.aws-ecs-setup.ecs_cluster_name
}

output "ecs_cluster_servicename" {
  value = module.aws-ecs-setup.ecs_cluster_servicename
}