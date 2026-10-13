# ==============================================================================
# 1. Random Suffix & Secure Password Generation
# ==============================================================================
resource "random_string" "db_suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ==============================================================================
# 2. Azure SQL Logical Server (Public Access Disabled)
# ==============================================================================
resource "azurerm_mssql_server" "main" {
  name                          = "sql-${local.name_prefix}-${random_string.db_suffix.result}"
  resource_group_name           = local.name_prefix
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.db_admin_username
  administrator_login_password  = random_password.db_password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  tags = local.common_tags
}

# ==============================================================================
# 3. Azure SQL Database (Cost-Effective Basic Tier)
# ==============================================================================
resource "azurerm_mssql_database" "shopnow" {
  name        = var.database_name
  server_id   = azurerm_mssql_server.main.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "Basic"
  max_size_gb = 5

  tags = local.common_tags
}

# ==============================================================================
# 4. Private DNS Zone & VNet Link for Azure SQL
# ==============================================================================
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = local.name_prefix
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${local.name_prefix}-sql-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
  resource_group_name   = local.name_prefix
  tags                  = local.common_tags
}

# ==============================================================================
# 5. Private Endpoint in DB Subnet (Port 1433 Private Link)
# ==============================================================================
resource "azurerm_private_endpoint" "sql" {
  name                = "${local.name_prefix}-sql-pe"
  location            = var.location
  resource_group_name = local.name_prefix
  subnet_id           = data.azurerm_subnet.db.id

  private_service_connection {
    name                           = "${local.name_prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = local.common_tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.sql
  ]
}

# ==============================================================================
# 6. Store Database Credentials in Azure Key Vault
# ==============================================================================
resource "azurerm_key_vault_secret" "db_admin_username" {
  name         = "db-admin-username"
  value        = var.db_admin_username
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "db_admin_password" {
  name         = "db-admin-password"
  value        = random_password.db_password.result
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "db_host" {
  name         = "db-host"
  value        = azurerm_mssql_server.main.fully_qualified_domain_name
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "db_port" {
  name         = "db-port"
  value        = "1433"
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "db_name" {
  name         = "db-name"
  value        = var.database_name
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${var.database_name};Persist Security Info=False;User ID=${var.db_admin_username};Password=${random_password.db_password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = data.azurerm_key_vault.main.id
  tags         = local.common_tags
}