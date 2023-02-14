terraform {
  required_providers {
    aws = {
      alias = "develop"
      region = var.east_region
      profile = "develop"
      source = "hashicorp/aws"
      versions = "~> 4.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
  }
}