variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  type = list(string)
  description = "AZs to create subnets into"
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  type = list(string)
  description = "subnets to create for public network traffic, one per AZ"
}

variable "vpc_private_subnets" {
  type = list(string)
  description = "subnets to create for private network traffic, one per AZ"
}

variable "vpc_database_subnets" {
  type = list(string)
  description = "subnets to create for private network traffic, one per AZ"
}

variable "public_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for public subnets"
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
  }
}

variable "private_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for private subnets"
  default = {
    "us-east-1a" = 3
    "us-east-1b" = 4
  }
}

variable "database_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for database subnets"
  default = {
    "us-east-1a" = 5
    "us-east-1b" = 6
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}

