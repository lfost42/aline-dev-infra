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
  profile = var.aline_profile
  region  = var.aline_region
}

module "vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
}
