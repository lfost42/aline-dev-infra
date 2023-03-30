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
  region  = var.region
}

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

module "ansible_vpc" {
  source = "../../../modules/vpc"

  infra_env              = var.infra_env
  vpc_cidr               = var.ansible_cidr
  cidr_bits              = var.ansible_cidr_bits
  az_count               = var.ansible_az_count
  create_public_subnet   = var.ansible_public_subnet
  create_private_subnet  = var.ansible_private_subnet
  create_database_subnet = var.ansible_database_subnet
  vpc_type               = var.ansible_vpc_type
}

# module "ansible-control-node" {
#   source = "../../../modules/ec2"
#   infra_role      = var.ansible_infra_role_0
#   project         = var.ansible_project
#   key_name        = var.ansible_key
#   infra_env       = var.infra_env
#   subnet          = module.ansible_vpc.vpc_public_subnet_ids[0]
#   security_groups = [module.ansible_vpc.security_group_public]
#   instance_ami    = var.host_ami
# }

module "ansible-managed-node1" {
  source = "../../../modules/ec2"
  infra_role      = var.ansible_infra_role_1
  project         = var.ansible_project
  key_name        = var.ansible_key
  infra_env       = var.infra_env
  subnet          = module.ansible_vpc.vpc_public_subnet_ids[0]
  security_groups = [module.ansible_vpc.security_group_public]
  instance_ami    = var.node1_ami
}

module "ansible-managed-node2" {
  source = "../../../modules/ec2"
  infra_role      = var.ansible_infra_role_2
  project         = var.ansible_project
  key_name        = var.ansible_key
  infra_env       = var.infra_env
  subnet          = module.ansible_vpc.vpc_public_subnet_ids[0]
  security_groups = [module.ansible_vpc.security_group_public]
  instance_ami    = var.node2_ami
}

module "ansible-managed-node3" {
  source = "../../../modules/ec2"
  infra_role      = var.ansible_infra_role_3
  project         = var.ansible_project
  key_name        = var.ansible_key
  infra_env       = var.infra_env
  subnet          = module.ansible_vpc.vpc_public_subnet_ids[0]
  security_groups = [module.ansible_vpc.security_group_public]
  instance_ami    = var.node3_ami
}

# ./run develop aline-eks-app init