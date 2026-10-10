# Public Subnet NSG
resource "azurerm_network_security_group" "public_subnet" {
  resource_group_name = local.name_prefix
  name                = "${local.name_prefix}-public-nsg"
  location            = var.location

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# App Subnet NSG
resource "azurerm_network_security_group" "app_subnet" {
  resource_group_name = local.name_prefix
  name                = "${local.name_prefix}-app-nsg"
  location            = var.location

  security_rule {
    name                       = "Allow-Web-To-App"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = var.public_subnet_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# Database Subnet NSG
resource "azurerm_network_security_group" "db_subnet" {
  resource_group_name = local.name_prefix
  name                = "${local.name_prefix}-db-nsg"
  location            = var.location

  security_rule {
    name                       = "Allow-App-To-DB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = var.app_subnet_cidr
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}