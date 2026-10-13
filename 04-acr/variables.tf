variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "shopnow"

}
variable "environment" {
  type        = string
  description = "name of the environment"

}
variable "location" {
  type        = string
  default     = "eastus"
  description = "name of the location"

}
variable "vnet_name" {
  type        = string
  description = "Name of the vnet"

}
variable "db_subnet_name" {
  type        = string
  description = "name of the db subnet"

}
variable "app_subnet_name" {
  type = string
  description = "name of the app subnet"
  
}