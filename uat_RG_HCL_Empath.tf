# Azure provider
provider azurerm {
    features {}
}

# resource group
resource azurerm_resource_group uat_db_rg {
    name     = RG-Empath-UAT
    location = East US
}

# VNET
resource azurerm_virtual_network uat_vnet {
  name                = DBfront-uat-vnet
  address_space       = [10.0.0.0/16]
  location            = azure_resource_group.uat_db_rg.location
  resource_group_name = azure_resource_group.uat_db_rg.name
}

# subnet
resource azurerm_subnet uat_subnet {
  name                 = internal-uat
  resource_group_name  = azurerm_resource_group.uat_db_rg.name
  virtual_network_name = azurerm_virtual_network.uat_vnet.name
  address_prefixes     = [10.0.2.0/24]
}

# Network Security Group for SQL
resource azurerm_network_security_group db_nsg {
  name                = empath-uat-db-nsg
  location            = azure_resource_group.uat_db_rg.location
  resource_group_name = azure_resource_group.uat_db.rg.name

  # allow db traffic SQL port 1433
  security_rule {
    name                       = allow_db_port
    priority                   = 100
    direction                  = inbound
    access                     = allow
    protocol                   = Tcp
    source_port_range          = *
    destination_port_range     = 1433
    source_address_prefix      = 10.0.1.0/24 # app subnet
    destination_address_prefix = *
  }
}

# Network Interface with NSG Association
resource azurerm_network_interface uat_db_nic {
   name                = emapth-uat-db-nic
   location            = azurerm_resource_group.uat_db_rg.location
   resoruce_group_name = azurerm_resource_group.uat_db_rg.name
  
  ip_configuration {
    name                          = internal
    subnet_id                     = azurerm_subnet.uat_subnet.id
    private_ip_address_allocation = Static
    private_ip_address            = 10.0.2.10
 } 
}

# bind nic to NSG
resource azure_rm_network_interface_security_group_association
nsg_assoc {
  network_interface_id   = azurerm_network_interface.uat_db_nic.id
  network_security_group = azurerm_network_security_group.db_nsg.id
}