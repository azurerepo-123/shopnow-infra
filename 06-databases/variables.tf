variable "project_name" {
  description = "Project name"
  type        = string
  default     = "shopnow"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNet created in 01-vnet"
  type        = string
}

variable "db_subnet_name" {
  description = "Name of the db subnet created in 01-vnet"
  type        = string
}

variable "azure_key_vault" {
  description = "Name of the Key Vault created in 03-keyvault"
  type        = string
}

variable "db_admin_username" {
  description = "Administrator username for Azure SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "database_name" {
  description = "Database name to create"
  type        = string
  default     = "shopnow_db"
}