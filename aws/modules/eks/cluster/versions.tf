# Terraform Block
terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }      
  }
}

# Provider Block
provider "aws" {
  region  = "us-east-1"
  profile = "dev-infra"
}
/*
$HOME/.aws/credentials
*/