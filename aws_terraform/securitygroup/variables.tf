variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ingress_rules" {
  type = map(object({
    description             = optional(string)
    from_port               = number
    to_port                 = number
    protocol                = string
    cidr_blocks             = optional(list(string), [])
    ipv6_cidr_blocks        = optional(list(string), [])
    source_security_groups  = optional(list(string), [])
    self_reference          = optional(bool, false)
  }))
  default = {}
}

variable "egress_rules" {
  type = map(object({
    description            = optional(string)
    from_port              = number
    to_port                = number
    protocol               = string
    cidr_blocks            = optional(list(string), [])
    ipv6_cidr_blocks       = optional(list(string), [])
    self_reference         = optional(bool, false)
  }))
  default = {}
}