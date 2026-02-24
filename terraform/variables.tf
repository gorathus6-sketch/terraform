variable "location" {
  description = "Azure region for Empath DEV resources"
  type        = "string
  default     = "eastus"
}

variable "tags" {
    description = "Common tags for all resources"
    type        = map(string)
    default = {
        environment = "dev"
        project     = "empath"
        owner       = "tif"
    }
}

variable "address_space" {
    description = "VNet address space"
    type        = list(string)
    default     = ["10.10.0.0/16"]
}

variable "db_subnet_prefix" {
    description = "DB subnet address prefix"
    type        = string
    default     = "10.10.1.0/24"
}