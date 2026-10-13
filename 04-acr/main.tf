resource "random_string" "acr_suffix" {
  length  = 4
  upper   = false
  special = false
}

# Container Registry (Private, Premium)
resource "azurerm_container_registry" "main" {
  name                          = "acr${var.project_name}${var.environment}${random_string.acr_suffix.result}"
  location                      = var.location
  resource_group_name           = local.name_prefix
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
  tags                          = local.common_tags
}

# Private DNS Zone & VNet Link
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = local.name_prefix
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                 = "${local.name_prefix}-acr-dns-link"
  resource_group_name = local.name_prefix
  private_dns_zone_name   = azurerm_private_dns_zone.acr.name
  virtual_network_id   = data.azurerm_virtual_network.main.id
  registration_enabled = false
  tags                 = local.common_tags
}

# Private Endpoint (The Private Door in DB Subnet)
resource "azurerm_private_endpoint" "acr" {
  name                = "${local.name_prefix}-acr-pe"
  location            = var.location
  resource_group_name = local.name_prefix
  subnet_id           = data.azurerm_subnet.db.id

  private_service_connection {
    name                           = "${local.name_prefix}-acr-psc"
    private_connection_resource_id = azurerm_container_registry.main.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }

  tags = local.common_tags
}