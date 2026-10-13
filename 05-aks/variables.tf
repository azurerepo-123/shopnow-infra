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
variable "node_vm_size" {
  type        = string
  description = "node vm size"

}
variable "node_count" {
  type        = string
  description = "count of the node"

}
variable "kubernetes_version" {
    type = string
  
}