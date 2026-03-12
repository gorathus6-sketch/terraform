output "firewall_arn" {
  value = aws_networkfirewall_firewall.this.arn
}

output "firewall_policy_arn" {
  value = aws_networkfirewall_firewall_policy.this.arn
}

output "firewall_id" {
  value = aws_networkfirewall_firewall.this.id
}