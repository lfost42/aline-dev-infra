terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    dynamodb_table = "lf-aline-tflock"
  }
}

provider "aws" {
  # profile = var.aline_profile
  region  = var.aline_region
}

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

module "aline_vpc" {
  source = "../../../modules/vpc"

  infra_env              = var.infra_env
  vpc_cidr               = var.aline_cidr
  cidr_bits              = var.aline_cidr_bits
  az_count               = var.aline_az_count
  create_public_subnet   = var.aline_public_subnet
  create_private_subnet  = var.aline_private_subnet
  create_database_subnet = var.aline_database_subnet
  vpc_type               = var.aline_vpc_type
}

# ./run develop aline-base-infra init