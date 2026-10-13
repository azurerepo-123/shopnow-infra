# ==============================================================================
# 1. User-Assigned Managed Identity for AKS
# ==============================================================================
resource "azurerm_user_assigned_identity" "aks" {
  name                = "${local.name_prefix}-aks-identity"
  location            = var.location
  resource_group_name = local.name_prefix
  tags                = local.common_tags
}
# ==============================================================================
# 3. AKS Cluster in App Subnet
# ==============================================================================
resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.name_prefix}-aks"
  location            = var.location
  resource_group_name = local.name_prefix
  dns_prefix          = "${local.name_prefix}-aks"
  sku_tier            = "Standard"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  
  }

  default_node_pool {
    name            = "systempool"
    node_count      = var.node_count
    vm_size         = var.node_vm_size
    vnet_subnet_id  = data.azurerm_subnet.app.id
    os_disk_size_gb = 30
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = local.common_tags

}
# ==============================================================================
# 2. AcrPull Role Assignment (AKS -> ACR)
# ==============================================================================
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}