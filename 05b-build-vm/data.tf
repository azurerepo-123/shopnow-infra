data "azurerm_virtual_network" "main" {
  resource_group_name = local.name_prefix
  name                = var.vnet_name
}

data "azurerm_subnet" "app" {
  resource_group_name  = local.name_prefix
  virtual_network_name = var.vnet_name
  name                 = var.app_subnet_name
}