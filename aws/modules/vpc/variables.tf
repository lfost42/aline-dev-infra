variable "aws_region" {
    description = "Region in which AWS resources are to be created"
    type = string
    default = "us-east-1"
}

variable "project" {
  description = "Project deployed"
  type = string
  default = "aline"
}

variable "environment" {
  description = "Environment variable used as a prefix"
  type = string
  default = "dev"
}

# VPC Input Variables
variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = "cc"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string
  default = "10.0.0.0/16"
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type = list(string)
  default = ["10.0.151.0/24", "10.0.152.0/24"]
}

# VPC create database subnet group
variable "vpc_create_database_subnet_group" {
  description = "VPC create database subment group"
  type = bool
  default = true
}

# VPC Create Database Subnet Route Table
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type = bool
  default = true   
}

# VPC Enable NAT Gateway
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for private subnets"
  type = bool
  default = true
}