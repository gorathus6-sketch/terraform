output "role_arns" {
  value = { for k, v in aws_iam_role.roles : k => v.arn }
}

output "policy_arns" {
  value = { for k, v in aws_iam_policy.policies : k => v.arn }
}