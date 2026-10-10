variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "shopnow"

}
variable "environment" {
  type        = string
  description = "Name of the environment"

}
variable "location" {
  type        = string
  description = "location oh the project"
  default     = "eastus"

}
variable "vnet_name" {
    type = string
    description = "Name of the vnet"
  
}
variable "db_subnet_name" {
    type = string
    description = "name of the db subnet"
  
}
