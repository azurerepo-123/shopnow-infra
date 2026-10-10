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
variable "vnet_cidr" {
  description = "ip range of the vnet"
  type        = string
  default     = "10.0.0.0/16"

}
variable "public_subnet_cidr" {
  description = "ip range of public subnet"
  type        = string
  default     = "10.0.1.0/24"

}
variable "app_subnet_cidr" {
  description = "ip range of app subnet"
  type        = string
  default     = "10.0.2.0/24"

}

variable "db_subnet_cidr" {
  description = "ip range of db subnet"
  type        = string
  default     = "10.0.3.0/24"

}