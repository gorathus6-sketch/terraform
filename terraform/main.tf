locals {
  rg_name   = "RG-Empath-DEV"
  vnet_name = "vnetempathdev"
  nsg_name  = "NSG-DB-DEV"
}

module "rg_empath_dev" {
  source   = "./modules/resource_group"
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "network_empath_dev" {
  source              = "./modules/network"
  resource_group_name = module.rg_empath_dev.name
  location            = var.location
  vnet_name           = local.vnet_name
  address_space       = var.address_space
  db_subnet_prefix    = var.db_subnet_prefix
  tags                = var.tags
}

module "nsg_db_dev" {
  source              = "./modules/nsg"
  name                = local.nsg_name
  location            = var.location
  resource_group_name = module.rg_empath_dev.name
  subnet_id           = module.network_empath_dev.db_subnet_id
  tags                = var.tags
}

# Example rules - tweak as needed
inbound_rules = [
  {
    name                       = "allow-mssql-from-app"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.20.0.0/16" # app subnet range
    destination_address_prefix = "*"
  }
]