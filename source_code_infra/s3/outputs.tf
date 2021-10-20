output "s3_bucket"{
  value = module.aws-s3.s3_bucket
}

output "aws_api_arn" {
  value = module.aws-ecr.aws_api_arn
}

output "aws_web_arn" {
  value = module.aws-ecr.aws_web_arn
}

output "s3_bucket_id"{
  value = module.aws-s3.s3_bucket_id
}

output "aws_api_url" {
  value = module.aws-ecr.aws_api_url
}

output "aws_web_url" {
  value = module.aws-ecr.aws_web_url
}