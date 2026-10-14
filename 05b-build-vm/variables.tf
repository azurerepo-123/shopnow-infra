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
variable "app_subnet_name" {
  type        = string
  description = "name of the db subnet"

}
variable "acr_name" {
  type        = string
  description = "name of the acr"

}
variable "vm_size" {
  type        = string
  description = "vm size"

}
variable "admin_username" {
    type= string
    description = "admin_username"
}
variable "ssh_public_key" {
    type= string
    description= "shh key"
}