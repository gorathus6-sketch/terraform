resource "azurerm_firewall_policy" "this" {
    name                = var.name
    resource_group_name = var.resource_group_name
    location            = var.location
}
