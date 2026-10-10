resource "azurerm_virtual_network" "main" {
  resource_group_name = local.name_prefix
  name                = "${local.name_prefix}-vnet"
  location            = var.location
  address_space       = [var.vnet_cidr]
  tags                = local.common_tags

}
resource "azurerm_subnet" "public" {
  resource_group_name  = local.name_prefix
  name                 = "${local.name_prefix}-public-subnet"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}
resource "azurerm_subnet" "app" {
  resource_group_name  = local.name_prefix
  name                 = "${local.name_prefix}-app-subnet"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_cidr]
}
resource "azurerm_subnet" "db" {
  name                 = "${local.name_prefix}-db-subnet"
  resource_group_name  = local.name_prefix
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_cidr]
}