data "azurerm_virtual_network" "main" {
  resource_group_name = local.name_prefix
  name                = var.vnet_name

}
data "azurerm_subnet" "db" {
  resource_group_name  = local.name_prefix
  virtual_network_name = var.vnet_name
  name                 = var.db_subnet_name

}
data "azurerm_subnet" "app" {
  resource_group_name = local.name_prefix
  virtual_network_name = var.vnet_name
  name = var.app_subnet_name
  
}
data "azurerm_resources" "acr" {
  resource_group_name = local.name_prefix
  type = "Microsoft.ContainerRegistry/registries"
  
}
data "azurerm_container_registry" "acr" {
  resource_group_name = local.name_prefix
  name = data.azurerm_resources.acr.resources[0].name
}