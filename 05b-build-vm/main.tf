# 1. NSG: deny all inbound (VM has no public IP, so nothing should reach it)
resource "azurerm_network_security_group" "build" {
  name                = "${local.name_prefix}-build-vm-nsg"
  location            = var.location
  resource_group_name = local.name_prefix

  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# 2. NIC in the app subnet (private IP only, no public_ip_address_id)
resource "azurerm_network_interface" "build" {
  name                = "${local.name_prefix}-build-vm-nic"
  location            = var.location
  resource_group_name = local.name_prefix

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "build" {
  network_interface_id      = azurerm_network_interface.build.id
  network_security_group_id = azurerm_network_security_group.build.id
}

# 3. The RHEL 9 VM with a managed identity
resource "azurerm_linux_virtual_machine" "build" {
  name                            = "${local.name_prefix}-build-vm"
  location                        = var.location
  resource_group_name             = local.name_prefix
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.build.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-lvm-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    dockerfile_b64 = base64encode(file("${path.module}/../05-aks/ado-agent/Dockerfile"))
    startsh_b64    = base64encode(file("${path.module}/../05-aks/ado-agent/start.sh"))
  }))

  tags = local.common_tags
}

# 4. AcrPush for the VM identity (push images with no passwords)
resource "azurerm_role_assignment" "build_acr_push" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_linux_virtual_machine.build.identity[0].principal_id
}