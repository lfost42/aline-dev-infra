# Community VPC module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  # insert the 49 required variables here
  name = "aline-${var.infra_env}-vpc"
  cidr = var.vpc_cidr

  azs = var.azs

  # Single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.database_subnets

  tags = {
    Name = "aline-${var.infra_env}-vpc"
  }

  private_subnet_tags = {
    Role = "private"
  }

  public_subnet_tags = {
    Role = "public"
  }

  database_subnet_tags = {
    Role = "database"
  }
}