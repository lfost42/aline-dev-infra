# Define Local Values in Terraform
locals {
  owners = var.app
  environment = var.environment
  name = "${var.app}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
} 