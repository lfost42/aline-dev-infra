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

variable "db_password" {
  type        = string
  description = "database password"
  default = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical official
}

module "ec2_public" {
  source = "../../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "public"
  instance_size = "t3.small"
  instance_ami = data.aws_ami.ubuntu.id
  subnets = keys(module.vpc.vpc_public_subnets)
  security_groups = [module.vpc.security_group_public]
  create_eip = true
}

module "ec2_private" {
  source = "../../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "private"
  instance_size = "t3.medium"
  instance_ami = data.aws_ami.ubuntu.id
  instance_root_device_size = 20
  subnets = keys(module.vpc.vpc_private_subnets)
  security_groups = [module.vpc.security_group_private]
  create_eip = false
}

module "database" {
  source = "../../../modules/rds"
  infra_env = var.infra_env
  vpc_id = module.vpc.vpc_id
  # instance_class = "db.t3.medium"
  # subnets = module.vpc.database_subnets[*].id
  # username = "var.db_user"
  # password = "var.db_pass"
  depends_on = [module.vpc]
}

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