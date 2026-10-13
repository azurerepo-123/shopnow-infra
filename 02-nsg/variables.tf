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
variable "public_subnet_cidr" {
  type        = string
  description = "ip range of public subnet"
  default = "10.0.1.0/24"

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