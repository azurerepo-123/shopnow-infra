output "aks_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_identity_principal_id" {
  description = "Principal ID of the AKS Managed Identity"
  value       = azurerm_user_assigned_identity.aks.principal_id
}

output "kube_config_raw" {
  description = "Raw kubeconfig to connect with kubectl"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "key_vault_secrets_provider_identity_id" {
  description = "Client ID of the Key Vault Secrets Provider identity"
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].client_id
}