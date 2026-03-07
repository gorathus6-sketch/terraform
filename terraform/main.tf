module "resource_group" {
  source = "./modules/resource-group"
  name   = var.resource_group_name
  location = var.location
  tags = var.tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
}

module "nsg_web" {
  source              = "./modules/nsg"
  name                = "nsg-web-dev"
  resource_group_name = module.resource_group.name
  location            = var.location
  rules               = var.web_nsg_rules
}

module "nsg_db" {
  source              = "./modules/nsg"
  name                = "nsg-db-dev"
  resource_group_name = module.resource_group.name
  location            = var.location
  rules               = var.db_nsg_rules
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = var.keyvault_name
  resource_group_name = module.resource_group.name
  location            = var.location
  tenant_id           = var.tenant_id
  subnet_ids = [
    module.network.subnet_ids["web"],
    module.network.subnet_ids["db"]
  ]
}

module "loganalytics" {
  source              = "./modules/loganalytics"
  name                = var.loganalytics_name
  resource_group_name = module.resource_group.name
  location            = var.location
}

module "rbac_admins" {
  source               = "./modules/rbac"
  for_each             = toset(var.admin_object_ids)
  scope                = module.resource_group.id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

module "rbac_non_admins" {
  source               = "./modules/rbac"
  for_each             = toset(var.non_admin_object_ids)
  scope                = module.resource_group.id
  role_definition_name = "Reader"
  principal_id         = each.value
}

module "diagnostic_settings" {
  source             = "./modules/diagnostic-settings"
  target_resource_id = module.network.id
  workpsace_id       = module.loganalytics.id
  log_categories     = var.log_categories
  metric_categories  = var.metric_categories
}
