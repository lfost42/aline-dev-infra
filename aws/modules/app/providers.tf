# Terraform Block
terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 4.0"
    }        
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "dev-infra"
}
/*
$HOME/.aws/credentials
*/
