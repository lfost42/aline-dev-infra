terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    profile        = "aline"
    region         = "us-east-1"
    bucket         = "lf-aline-terraform"
    key            = "sanbox/test2/terraform.tfstate"
    dynamodb_table = "lf-aline-tflock"
  }
}

provider "aws" {
  profile = var.aline_profile
  region  = var.aline_region
}