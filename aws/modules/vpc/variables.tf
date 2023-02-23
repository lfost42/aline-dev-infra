variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/22"
}

variable "cidr_bits" {
  type = number
  description = "cidr bits for the cidr block"
}

variable "az_count" {
  type = number
  description = "number of availability zones"
}

variable "create_public_subnet" {
  type = bool
  description = "whether to include a public subnet in the vpc"
}

variable "create_private_subnet" {
  type = bool
  description = "whether to include a private subnet in the vpc"
}

variable "create_database_subnet" {
  type = bool
  description = "whether to include a database subnet in the vpc"
}

variable "vpc_type" {
  type = string
  description = "type of vpc"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    Owner       = "lynda"
  }
}
