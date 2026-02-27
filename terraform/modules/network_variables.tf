variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name"
}

variable "address_space" {
  type        = list(string)
  description = "VNet address space"
}

variable "db_subnet_prefix" {
  type         = string
  descriiption = "DB subnet address prefix"
}

variable "tags" {
  type        = map(string)
  description = "Tags for network resources"
  default     = {}
}
