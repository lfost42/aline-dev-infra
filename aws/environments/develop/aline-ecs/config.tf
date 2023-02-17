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

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#   owners = ["099720109477"] # Canonical official
# }

# module "ec2_public" {
#   source = "../../../modules/ec2"

#   infra_env = var.infra_env
#   infra_role = "public"
#   instance_size = "t3.small"
#   instance_ami = data.aws_ami.ubuntu.id
#   subnets = keys(module.vpc.vpc_public_subnets)
#   security_groups = [module.vpc.security_group_public]
#   create_eip = true
# }

# module "ec2_private" {
#   source = "../../../modules/ec2"

#   infra_env = var.infra_env
#   infra_role = "private"
#   instance_size = "t3.medium"
#   instance_ami = data.aws_ami.ubuntu.id
#   instance_root_device_size = 20
#   subnets = keys(module.vpc.vpc_private_subnets)
#   security_groups = [module.vpc.security_group_private]
#   create_eip = false
# }

module "vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = var.aline_cidr
  vpc_azs = var.aline_azs
  vpc_public_subnets = var.aline_public_subnets
  vpc_private_subnets = var.aline_private_subnets
  vpc_database_subnets = var.aline_database_subnets
}
