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

# resource "aws_db_subnet_group" "rds-private-subnet" {
#   name = "rds-private-subnet-group"
#   subnet_ids = module.vpc.vpc_database_subnet_ids
# }

# module "database" {
#   source = "../../../modules/rds"

#   infra_env = var.infra_env
#   vpc_id = module.vpc.vpc_id
#   db_instance_class = "db.t3.medium"
#   db_username = var.db_user"
#   db_password = var.db_pass"
#   depends_on = [module.vpc, resource.aws_db_subnet_group.rds-private-subnet]
# }

module "vpc" {
  source = "../../../modules/vpc"
  infra_env = var.infra_env
  vpc_cidr  = "10.0.0.0/17"
  azs = ["us-east-2a", "us-east-2b"] 
  public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 2)
  private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 2, 4)
  database_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)
}

# ./run develop aline-eks init