variable "firewall_name" {
  type = string
}

variable "firewall_policy_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "firewall_subnet_ids" {
  type = list(string)
}

variable "stateless_rule_groups" {
  type = map(object({
    capactiy = number
    priority = number
    rules = list (object({
      priority    = number
      actions     = list(string)
      source      = string
      destination = string
      protocols   = list(string)
      from_port   = number
      to_port     = number
    }))
  }))
  default = {}
}

variable "stateful_rule_groups" {
  type = map(object({
    capacity     = number
    rules_string = string
  }))
  default = {}
}

variable "stateless_default_actions" {
  type = list(string)
}

variable "stateless_frequent_default_actions" {
  type = list(string)
}

variable "log_destination_type" {
  type = string
  description = "CLOUDWATCH_LOG_GROUP or S3"
}

variable "log_destination" {
  type = map(string)
  description = "Map of log destination settings"
}

variable "tags" {
  type = map(string)
  default = {}
}