output "resource_group_name" {
  value = module.resource_group.name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "keyvault_uri" {
  value = module.keyvault.vault_uri
}
