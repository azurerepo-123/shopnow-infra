data "azurerm_subnet" "app" {
  resource_group_name  = local.name_prefix
  virtual_network_name = var.vnet_name
  name                 = var.app_subnet_name

}
data "azurerm_container_registry" "acr" {
  resource_group_name = local.name_prefix
  name = var.acr_name

}