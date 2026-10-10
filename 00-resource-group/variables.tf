variable "project_name" {
  type        = string
  default     = "shopnow"
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name (prod, dev, staging)"

}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region deploy the resources"

}