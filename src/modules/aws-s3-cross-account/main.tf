# Data Resource for terraform remote state.
data "terraform_remote_state" "infra" {
  backend = "s3"
  config  = {
    bucket   = var.state_bucket_name
    key      = "${var.infra_state}.tfstate"
    region   = "us-west-2"
    profile  = var.profile
  }
}

# Resource S3 Bucket.
resource "aws_s3_bucket" "artifact_pipeline_s3" {
  bucket = var.bucket_name
  acl    = "private"
  tags   = merge({ Name = "${local.prefix}-rds-secret" }, local.common_tags)
}

# Resource S3 bucket policy.
resource "aws_s3_bucket_policy" "artifact_pipeline_s3" {
  bucket = aws_s3_bucket.artifact_pipeline_s3.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "artifact_pipeline_s3-policy",
  "Statement": [
    {
      "Sid": "Allow  placing objects",
      "Effect": "Allow",
      "Principal": {
          "Service": "codepipeline.amazonaws.com",
          "AWS": [
                  "arn:aws:iam::${var.account-id}:root",
                  "${data.terraform_remote_state.infra.outputs.cross_account_role_arn}"
              ]
      },
      "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
      ],
      "Resource": "${aws_s3_bucket.artifact_pipeline_s3.arn}/*"
    }
  ]
}
POLICY
}