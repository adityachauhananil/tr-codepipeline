output "fs-core-api-ecs-task-execution-role" {
  value = aws_iam_role.fs-core-api-ecs-task-execution-role.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_servicename" {
  value = aws_ecs_service.ecs_service.name
}