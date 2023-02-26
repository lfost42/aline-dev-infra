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
    bucket  = "lf-aline-terraform"
    key     = "test/test-aline-eks-app/terraform.tfstate"
  }
}

provider "aws" {
  region  = "us-east-1"
}

module "test_vpc" {
  source = "../../../modules/vpc"

  infra_env = "test"
  vpc_cidr = "10.1.0.0/22"
  cidr_bits = 6
  create_public_subnet = true
  create_private_subnet = false
  create_database_subnet = false
  vpc_type = "Main"
}

# ./run test test-aline-eks-app init