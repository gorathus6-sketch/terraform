resource "aws_iam_role" "roles" {
  for_each = var.roles

  name               = each.key
  assume_role_policy = each.value.trust_policy_json
  description        = each.value.description

  tags = var.tags
}

resource "aws_iam_policy" "policies" {
  for_each = var.policies

  name        = each.key
  description = each.value.description
  policy      = each.value.policy_json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "managed_attachments" {
  for_each = {
    for role_name, role in var.roles :
    role_name => role.managed_policy_arns
  }

  role = aws_iam_role.roles[each.key].name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = {
    for role_name, role in var.roles
    role_name => role.inline_policies
  }

  name   = "${each.key}-inline"
  role   = aws_iam_role.roles[each.key].id
  policy = each.value
}
