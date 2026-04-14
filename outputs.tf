output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "vm_identity_principal_id" {
  value = azurerm_linux_virtual_machine.main.identity[0].principal_id
}
