terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    # uses AWS info from Jenkins pipeline or local default
    # profile        = "aline"
    region         = "us-east-1"
    dynamodb_table = "lf-aline-tflock"
  }
}

provider "aws" {
  # uses AWS info from Jenkins pipeline or local default
  # profile        = "aline"
  region         = "us-east-1"
}