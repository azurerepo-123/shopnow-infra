output "sql_server_id" {
  description = "The ID of the Azure SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "sql_server_name" {
  description = "The name of the Azure SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the Azure SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "database_name" {
  description = "The name of the provisioned Azure SQL database"
  value       = azurerm_mssql_database.shopnow.name
}

output "key_vault_secret_connection_string_id" {
  description = "The Key Vault Secret ID for the SQL connection string"
  value       = azurerm_key_vault_secret.db_connection_string.id
}