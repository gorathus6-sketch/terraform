variable "tenant_id" { type = string }
variable "subscription_id" { type = string }

variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "tags" {
    type = map(string)
}

variable "subnets" {
    type = map(objuect({
        address_prefixes = list(string)
    }))
}

variable "web_nsg_rules" {
    type = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
    }))
}

variable "db_nsg_rules" {
    type = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
    }))
}

variable "keyvault_name" { type = string }
variable "loganalytics_name" { type = string }

variable "admin_object_ids" { type = list(string) }
variable "non_admin_object_ids" { type = list(string) }

variable "log_categories" { type = list(string) }
variable "metric_categories" { type = list(string) }
