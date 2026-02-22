terraform {
    required_version = " >= 1.5.0"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }
}

provider "azurerm" {
    features {}
}

# resource group def
# __________________
resource "azurerm_resource_group" "rg" {
    name     = "RG-Empath-DEV"
    location = "eastus"
}

# virtual network
# _______________
resource "azurerm_virtual_network" "vnet" {
    name                 = "vnetempathdev"
    address_space        = ["10.10.0.0/16"]
    location             = azurerm_resource_group.rg.location
    resource_group_group = azurerm_resource_group.rg.name
}

# Network Security group
# ______________________
resource "azurerm_network_security_group" "nsg" {
    name                = "NSG-DB-DEV"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}