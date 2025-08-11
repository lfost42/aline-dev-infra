module "aline-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  # private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = false
  # single_nat_gateway   = false
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
      VPC                                         = module.aline_vpc.vpc_id
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = 1
      Network                                     = "Public"
  }

  # private_subnet_tags = {
  #   VPC                                         = module.aline_vpc.vpc_id
  #   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"           = 1
  #   Network                                     = "Private"
  # }

}

output "vpc_id" {
  value = module.aline_vpc.vpc_id
}

output "aline_public_subnets" {
  value = module.aline_vpc.public_subnets
}

# output "aline_private_subnets" {
#   value = module.aline_vpc.private_subnets
# }

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.2.0.0/18"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "aline"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

# variable "private_subnets" {
#   type        = list(string)
#   description = "Private subnet cidr"
#   default     = ["10.2.0.0/22", "10.2.4.0/24"]
# }

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet cidr"
  default     = ["10.2.8.0/24", "10.2.12.0/24"]
}