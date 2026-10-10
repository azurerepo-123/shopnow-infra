locals {
  name_prefix= "${var.project_name}-${var.environment}"

  common_tags={
    project_name= "shopnow"
    environment="prod"
    location= "eastus"
    managedby= "terraform"
  }
}