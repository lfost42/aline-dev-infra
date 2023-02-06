locals {
  # instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
  region = "us-east-1"
  name = "${var.project}-${var.environment}"
  common_tags = {
    project = var.project
    environment = var.environment
  }
}

# Create VPC terraform module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  # VPC basic details
  name = "${local.name}-VPC"
  cidr = var.vpc_cidr_block
  azs                 = ["${local.region}a", "${local.region}b"]
  private_subnets     = var.vpc_private_subnets
  public_subnets      = var.vpc_public_subnets

  # Database Subnets
  database_subnets = var.vpc_database_subnets
  create_database_subnet_group = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
  vpc_tags = local.common_tags

  public_subnet_tags = {
    Type = "public subnets"
  }

  private_subnet_tags = {
    Type = "private subnets"
  }

  database_subnet_tags = {
    Type = "private database subnets"
  }
}
