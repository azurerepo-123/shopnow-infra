# Block 1: find who I am (from az login)
data "azurerm_client_config" "current" {}

# Block 2: find the VNet from 01-vnet
data "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = local.name_prefix
}

# Block 3: find the db subnet from 01-vnet
data "azurerm_subnet" "db" {
  name                 = var.db_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = local.name_prefix
}

# Block 4: 4 random letters (the vault name must be unique in all of Azure)
resource "random_string" "kv_suffix" {
  length  = 4
  upper   = false
  special = false
}

# Block 5: the safe (Key Vault)
resource "azurerm_key_vault" "main" {
  name                = "kv-${local.name_prefix}-${random_string.kv_suffix.result}"
  location            = var.location
  resource_group_name = local.name_prefix
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = local.common_tags
}

# Block 6: your key to the safe (admin role)
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Block 7: the phone book (private DNS) and its link to the VNet
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.name_prefix
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                 = "${local.name_prefix}-kv-dns-link"
  resource_group_name = local.name_prefix
  private_dns_zone_name  = azurerm_private_dns_zone.kv.name
  virtual_network_id   = data.azurerm_virtual_network.main.id
  registration_enabled = false
  tags                 = local.common_tags
}

# Block 8: the private door, inside the db subnet
resource "azurerm_private_endpoint" "kv" {
  name                = "${local.name_prefix}-kv-pe"
  location            = var.location
  resource_group_name = local.name_prefix
  subnet_id           = data.azurerm_subnet.db.id

  private_service_connection {
    name                           = "${local.name_prefix}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }

  tags = local.common_tags
}