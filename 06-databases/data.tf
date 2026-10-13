data "azurerm_virtual_network" "main" {
  resource_group_name = local.name_prefix
  name                = var.vnet_name

}
data "azurerm_subnet" "db" {
  virtual_network_name = var.vnet_name
  resource_group_name  = local.name_prefix
  name                 = var.db_subnet_name

}
data "azurerm_key_vault" "main" {
  resource_group_name = local.name_prefix
  name                = var.azure_key_vault

}