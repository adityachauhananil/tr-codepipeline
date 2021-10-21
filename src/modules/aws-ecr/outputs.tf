output "aws_api_arn" {
  value = aws_ecr_repository.core_app_api.arn
}

output "aws_web_arn" {
  value = aws_ecr_repository.core_app_web.arn
}

output "aws_web_url"{
  value = aws_ecr_repository.core_app_web.repository_url
}

output "aws_api_url"{
  value = aws_ecr_repository.core_app_api.repository_url
}