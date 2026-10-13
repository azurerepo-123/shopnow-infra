output "acr_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.main.id
}

output "acr_name" {
  description = "The globally unique Name of the Container Registry"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "The URL used to log in and push/pull images (e.g., acrshopnowprod3aez.azurecr.io)"
  value       = azurerm_container_registry.main.login_server
}

output "acr_private_endpoint_ip" {
  description = "The Private IP assigned to ACR inside the DB subnet"
  value       = azurerm_private_endpoint.acr.private_service_connection[0].private_ip_address
}