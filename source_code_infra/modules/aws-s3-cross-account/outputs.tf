output "s3_bucket"{
  value = aws_s3_bucket.artifact_pipeline_s3.arn
}

output "s3_bucket_id"{
  value = aws_s3_bucket.artifact_pipeline_s3.id
}
