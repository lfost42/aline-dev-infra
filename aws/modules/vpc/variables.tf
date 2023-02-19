variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/17"
}

variable "cidr_bits" {
  type = number
  description = "cidr bits for the cidr block"
  default = 9
}

variable "az_count" {
  type = number
  description = "number of availability zones"
  default = 2
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

