output "key_vault_id" {
    description = "id of azure key vault"
    value = azurerm_key_vault.main.id
  
}

output "key_vault_name" {
    description = "name of the key vault"
    value = azurerm_key_vault.main.name
  
}
output "key_vault_uri" {
    description = "key vault uri"
    value = azurerm_key_vault.main.vault_uri
  
}