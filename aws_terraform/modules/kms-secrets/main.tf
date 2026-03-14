resource "aws_kms_key" "this" {
  description             = var.kms_description
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.kms_policy_json
  deletion_window_in_days = var.deletion_window_in_days
  tags                    = var.tags
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.this.key_id
}

resource  "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name        = each.key
  description = each.value.description
  kms_key_id  = aws_kms_key.this.arn
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each {
    for name, secret in var.secrets :
    name => secret if secret.initial_value != null
  }

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.initial_value
}
