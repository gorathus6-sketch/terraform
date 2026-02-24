variable "name" {
  type        = string
  description = "NSG name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
    type        = string
    description = "Resource group name"
}

variable "subnet_id" {
    type        = string
    description = "Subnet ID to associate with NSG"
}

variable "tags" {
  type        = string
  description = "Tags for NSG"
  default     = {}
}

variable "inbound_rules" {
  description = "List of inbound security rules"
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
  default = []
}