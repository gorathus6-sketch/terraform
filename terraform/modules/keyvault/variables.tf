variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id" {type = string }
variable "subnet_ids" { type = list(string) }