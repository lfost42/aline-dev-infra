module "aline_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${var.project}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
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



# #################################
# # VPC Module Code
# #################################
# module "aline_vpc" {
#   source = "../../../modules/vpc"

#   infra_env              = var.infra_env
#   vpc_cidr               = var.aline_cidr
#   cidr_bits              = var.aline_cidr_bits
#   az_count               = var.aline_az_count
#   create_public_subnet   = var.aline_public_subnet
#   create_private_subnet  = var.aline_private_subnet
#   create_database_subnet = var.aline_database_subnet
#   vpc_type               = var.aline_vpc_type
# }

# variable "aline_az_count" {
#   type        = number
#   description = "desired number of availability zones"
#   default     = 2
# }

# variable "aline_cidr_bits" {
#   type        = number
#   description = "number of cidr bits"
#   default     = 4
# }

# variable "aline_cidr" {
#   type        = string
#   description = "project cidr subnet block"
#   default     = "10.2.0.0/18"
# }

# variable "aline_public_subnet" {
#   type        = bool
#   description = "Include a public subnet in the VPC"
#   default     = true
# }

# variable "aline_private_subnet" {
#   type        = bool
#   description = "Include a private subnet in the VPC"
#   default     = true
# }

# variable "aline_database_subnet" {
#   type        = bool
#   description = "Include a database subnet in the VPC"
#   default     = true
# }

# variable "aline_vpc_type" {
#   type        = string
#   description = "type of vpc"
#   default     = "Main"
# }

# output "vpc_id" {
#   value = module.aline_vpc.vpc_id
# }
# output "vpc_cidr" {
#   value = module.aline_vpc.vpc_cidr
# }
# output "vpc_public_subnets" {
#   value = module.aline_vpc.vpc_public_subnets
# }
# output "vpc_private_subnets" {
#   value = module.aline_vpc.vpc_private_subnets
# }
# output "vpc_database_subnets" {
#   value = module.aline_vpc.vpc_database_subnets
# }