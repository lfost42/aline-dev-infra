# VPC Name
variable "vpc_name" {
  description = "VPC  ame"
  type = string 
  default = "${local.name}-${local.environment}-VPC"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type = string 
  default = "10.0.0.0/16"
}

# VPC availability zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type = list(string)
  default = ["${local.region}a", "${local.region}b"]
}

# VPC public subnets
variable "vpc_public_subnets" {
  description = "VPC public subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# VPC private subnets
variable "vpc_private_subnets" {
  description = "VPC private subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC database subnets
variable "vpc_database_subnets" {
  description = "VPC database subnets"
  type = list(string)
  default = ["10.0.151.0/24", "10.0.152.0/24"]
}

# VPC create database subnet group
variable "vpc_create_database_subnet_group" {
  description = "VPC create database subnet group"
  type = bool
  default = true 
}

# VPC create database subnet route table
variable "vpc_create_database_subnet_route_table" {
  description = "VPC create database subnet route table"
  type = bool
  default = true   
}

# VPC enable NAT gateway
variable "vpc_enable_nat_gateway" {
  description = "Private subnet outbound communication"
  type = bool
  default = true  
}





