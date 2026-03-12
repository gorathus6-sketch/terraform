resource "aws_networkfirewall_rule_group" stateless" {
  for_each = var.stateless_rule_groups

  name     = each.key
  capacity = each.value.capacity
  type     = "STATELESS"

  rule_group = jsonencode({
    rules_source = {
      stateless_rules_and_custom_actions = {
        stateless_rules = [
          for rule in each.value.rules : {
            priority = rule.priority
            rule_definition = {
              actions = rule.actions
              match_attributes = {
                sources = [{ address_definition = rule.source }]
                destinations = [{ address_definition = rule.destination }]
                protocols = rule.protocols
                source_ports = [{ from_port = rule.from_port, to_port = rule.to_port }]
                destination_ports = [{ from_port = rule.from_port, to_port = rule.to_port }]

              }
            }
          }
        ]
      }
    }
  })
}

resource "aws_networkfirewall_rule_group" "stateful" {
  for_each = var.stateful_rule_groups

  name     = each.key
  capacity = each.value.capacity
  type     = "STATEFUL"

  rule_group = jsonencode({
    rules_source = {
      rules_string = each.value.rules_string
    }
  })
}

resource "aws_networkfirewall_firewall_policy" "this" {
  name = var.firewall_policy_name

  firewall_policy = {
    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions
  
    stateless_rule_group_references = [
      for name, rg in aws_networkfirewall_rule_group_stateless : {
        resource_arn = rg.arn
        priority     = var.stateless_rule_groups[name].priority
      }
    ]

    stateful_rule_group_references = [
      for name, rg in aws_networkfirewall_rule_group_stateful : {
        resource_arn = rg.arn
      }
    ]
  }
}

resource "aws_networkfirewall_firewall" "this" {
  name                = var.firewall_name
  vpc_id              = var.vpc_id
  subnet_mapping      = [for id in var.firewall_subnet_ids : { subnet_id = id }]
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn 

  delete_protection = false
  subnet_change_protection = false
  firewall_policy_change_protection = false

  tags = var.tags
}

resource "aws_networkfirewall_logging_configuration" "this" {
  firewall_arn = aws_networkfirewall_firewall.this.arn

  logging_configuration {
    log_destination_config {
      log_destination = var.log_destination
      log_destination_type = var.log_destination_type
      log_type = "FLOW"
    }

    log_destination_config {
      log_destination = var.log_destination
      log_destination_type = var.log_destination_type
      log_type = "ALERT"
    }
  }
}
