variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "lf-eks"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "lf-eks"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet cidr"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet cidr"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}