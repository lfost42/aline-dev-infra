terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    profile = "aline"
    region  = "us-east-1"
  }
}

provider "aws" {
  profile = var.aline_profile
  region  = var.aline_region
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = module.vpc.vpc_database_subnet_ids
}

module "database" {
  source = "../../../modules/rds"

  infra_env = var.infra_env
  db_instance_class = var.db_instance_class
  db_username = var.db_user
  db_password = var.db_pass
  depends_on = [module.vpc, resource.aws_db_subnet_group.rds-private-subnet]
}

module "vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = var.aline_cidr
  vpc_azs = var.aline_azs
  vpc_public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 2)
  vpc_private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 2, 4)
  vpc_database_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)
}

# ./run develop aline-eks init