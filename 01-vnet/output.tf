output "vnet_id" {
  description = "display vnet id"
  value       = azurerm_virtual_network.main.id

}
output "public_subnet_id" {
  description = "display the public subnet id"
  value       = azurerm_subnet.public.id

}
output "app_subnet_id" {
  description = "display the app subnet id"
  value       = azurerm_subnet.app.id

}
output "db_subnet_id" {
  description = "display the db subnet id"
  value       = azurerm_subnet.db.id

}