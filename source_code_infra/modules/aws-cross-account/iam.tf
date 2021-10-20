# Resource Cross account role.
resource "aws_iam_role" "cross_account_role" {
  name = var.cross-account-role-name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "codepipeline.amazonaws.com"
          ],
          AWS = [
            "arn:aws:iam::${var.cross-account-id}:root"
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

# Resource IAM role attachment.
resource "aws_iam_role_policy_attachment" "cross_account_role_ecs" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "cross_account_role_codedeploy" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}