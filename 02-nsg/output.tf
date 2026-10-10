output "public_nsg_ip" {
  description = "ID of the public subnet NSG"
  value       = azurerm_network_security_group.public_subnet.id
}
output "app_nsg_ip" {
  description = "ID of the App subnet NSG"
  value       = azurerm_network_security_group.app_subnet.id
}
output "db_subnet_ip" {
  value       = azurerm_network_security_group.db_subnet.id
  description = "ID of the DB subnet NSG"

}