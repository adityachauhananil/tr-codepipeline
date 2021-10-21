output "cross_account_role" {
  value = aws_iam_role.cross_account_role.name
}

output "cross_account_role_arn" {
  value = aws_iam_role.cross_account_role.arn
}