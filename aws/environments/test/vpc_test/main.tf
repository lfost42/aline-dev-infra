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

  infra_env = var.infra_env
  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
  cidr_bits = var.cidr_bits
  create_public_subnet = var.create_public_subnet
  create_private_subnet = var.create_private_subnet
  create_database_subnet = var.create_database_subnet
  vpc_type = var.vpc_type
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "test"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.1.0.0/22"
}

variable "cidr_bits" {
  type = number
  description = "cidr bits for the cidr block"
  default = 6
}

variable "az_count" {
  type        = number
  description = "number of availability zones"
  default     = 2
}

variable "create_public_subnet" {
  type = bool
  description = "whether to include a public subnet in the vpc"
  default = true
}

variable "create_private_subnet" {
  type = bool
  description = "whether to include a private subnet in the vpc"
  default = false
}

variable "create_database_subnet" {
  type = bool
  description = "whether to include a database subnet in the vpc"
  default = false
}

variable "vpc_type" {
  type = string
  description = "type of vpc"
  default = "Main"
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "az_names" {
  value = data.aws_availability_zones.available.names
}

output "out_id" {
  value = module.test_vpc.vpc_id
}

output "out_cidr" {
  value = module.test_vpc.vpc_cidr
}

output "public_subnets" {
  value = module.test_vpc.vpc_public_subnets
}