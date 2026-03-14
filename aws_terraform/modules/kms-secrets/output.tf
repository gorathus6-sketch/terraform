output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "kms_key_id" {
  value = aws_kms_key.this.key_id
}

output "secret_arns" {
  value = { for k, v in aws_secretsmanager_secrets : k => v.arn }
}