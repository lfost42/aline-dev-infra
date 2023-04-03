variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "lf-eks"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/17"
}

variable "cidr_bits" {
  type        = number
  description = "cidr bits for the cidr block"
  default     = 5
}

variable "az_count" {
  type        = number
  description = "number of availability zones"

  validation {
    condition = var.az_count <= 5
    error_message = "This VPC cannot accomodate more than 5 availability zones."
  }
}

variable "create_public_subnet" {
  type        = bool
  description = "whether to include a public subnet in the vpc"
}

variable "create_private_subnet" {
  type        = bool
  description = "whether to include a private subnet in the vpc"
}

variable "create_database_subnet" {
  type        = bool
  description = "whether to include a database subnet in the vpc"
}

variable "vpc_type" {
  type        = string
  description = "type of vpc"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
  }
}
