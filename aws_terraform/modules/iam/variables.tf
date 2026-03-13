variable "roles" {
  type = map(object({
    description         = optional(string)
    trust_policy_json   = string
    managed_policy_arns = optional(list(string), [])
    inline_polcies      = optional(string, null)
  }))
  default = {}
}

variable "policies" {
  type = map(object({
    description = optional(string)
    policy_json = string
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}