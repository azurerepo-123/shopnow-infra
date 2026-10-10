locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    project_name = var.project_name
    environment  = var.environment
    managedby    = "terraform"
  }
}