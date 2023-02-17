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
  profile = "aline"
  region  = "us-east-1"
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "develop"
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = module.vpc.vpc_database_subnet_ids
}

module "database" {
  source = "../../../modules/rds"

  infra_env = var.infra_env
  vpc_id = module.vpc.vpc_id
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
  vpc_public_subnets = var.aline_public_subnets
  vpc_private_subnets = var.aline_private_subnets
  vpc_database_subnets = var.aline_database_subnets
}

# ./run develop aline-eks init