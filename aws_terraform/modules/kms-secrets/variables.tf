variable "kms_description" {
  type        = string
  default     = "KMS key for application secrets"
}

variable "kms_alias" {
  type = string
}

variable "enable_key_rotation" {
  type = bool
  default = true
}

variable "kms_policy_json" {
  type        = string
  description = "Full KMS key policy JSON"
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "secrets" {
  type = map(object({
    description = optional(string)
    initial_value = optional(string, null)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}