terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.25.0"
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

variable default_region {
  type = string
  description = "the region this infrastructure is in"
  default = "us-east-1"
}


data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Component"
    values = ["app"]
  }

  filter {
    name   = "tag:Project"
    values = ["aline"]
  }

  filter {
    name   = "tag:Environment"
    values = ["develop"]
  }

  owners = ["self"]
}

module "ec2_app" {
  source = "../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "public"
  instance_size = "t3.medium"
  instance_ami = data.aws_ami.app.id
  subnets = module.vpc.vpc_public_subnets
  security_groups = [module.vpc.security_group_public]
  tags = {
    Name = "aline-${var.infra_env}-public"
  }
  create_eip = true
}

module "ec2_worker" {
  source = "../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "private"
  instance_size = "t3.medium"
  instance_ami = data.aws_ami.app.id
  instance_root_device_size = 20
  subnets = module.vpc.vpc_private_subnets
  security_groups = [module.vpc.security_group_private]
  tags = {
    Name = "aline-${var.infra_env}-private"
  }
  create_eip = false
}

module "vpc" {
  source = "../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = "10.0.0.0/17"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4), 0, 2)
  private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4), 2, 4)
}
