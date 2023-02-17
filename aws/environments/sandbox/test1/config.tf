terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "lf-aline-terraform"
    key = "develop/ecs/terraform.tfstate"
    profile = "aline"
    region  = "us-east-1"
    dynamodb_table = "lf-aline-tflock"
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

module "vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = "10.0.0.0/17"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 2)
  private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 2, 4)
  database_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)
}
