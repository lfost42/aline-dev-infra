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
    key            = "develop/aline-base-infra/terraform.tfstate"
    dynamodb_table = "lf-aline-tflock"
  }
}

provider "aws" {
  profile = var.aline_profile
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

# module "ansible-host-node" {
#   source = "../../../modules/ec2"
#   infra_env       = var.infra_env
#   security_groups = [data.aws_security_group.public.id]
#   infra_role      = "public"
# }

# data "aws_security_group" "public" {
#     tags = {
#     Name = "lf-aline-${var.infra_env}-public-sg"
#     Role = "public"
#     Type = "main"
#   }
#   depends_on = [ module.aline_vpc ]
# }

# resource "aws_db_subnet_group" "rds_database_subnet" {
#   name       = join("-",["aline-rds-sg", random_string.random.result])
#   subnet_ids = module.aline_vpc.vpc_database_subnet_ids
# }

# module "database" {
#   source = "../../../modules/rds"

#   infra_env = var.infra_env
#   db_instance_class = var.db_instance_class
#   db_username = var.db_user
#   db_password = var.db_pass
#   aline_db_subnet_group_name = resource.aws_db_subnet_group.rds_database_subnet.name
#   depends_on = [module.aline_vpc, resource.aws_db_subnet_group.rds_database_subnet]
# }

# ./run develop aline-eks-app init