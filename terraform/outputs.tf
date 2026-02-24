output "resource_group_name" {
  value = module.rg_empath_dev.name
}

output "vnet_id" {
  value = module.network_empath_dev.vnet_id
}

output "db_subnet_id" {
    value = module.network_empath_dev.db_subnet_id
}

output "nsg_id" {
  value = module.nsg_db_dev.id
}