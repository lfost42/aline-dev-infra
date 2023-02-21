terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    profile = "aline"
    region  = "us-east-1"
  }
}

provider "aws" {
  profile = var.aline_profile
  region  = var.aline_region
}

# # to create a secret
# module "secrets_rotation" {
#   source = "./modules/secrets_rotation"

#   secrets = {
#     "my_secret_1" = {
#       secret_id = aws_secretsmanager_secret.my_secret_1.id
#     },
#     "my_secret_2" = {
#       secret_id = aws_secretsmanager_secret.my_secret_2.id
#     }
#   }
# }

# variable "secrets" {
#   type = map(object({
#     secret_id = string
#   }))
# }

module "aline_vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = var.aline_cidr
  cidr_bits = var.aline_cidr_bits
  az_count = var.aline_az_count
  create_public_subnet = var.aline_public_subnet
  create_private_subnet = var.aline_private_subnet
  create_database_subnet = var.aline_database_subnet
  vpc_type = var.aline_vpc_type
}

module "aline_eks_cluster" {
  source = "../../../modules/aline-eks-cluster"
  infra_env = var.infra_env
  cluster_subnet_ids      = flatten([module.aline_vpc.vpc_private_subnet_ids, module.aline_vpc.vpc_public_subnet_ids, module.aline_vpc.vpc_database_subnet_ids])

  endpoint_private_access = "true"
  endpoint_public_access  = "true"
  depends_on = [module.aline_vpc]
}

module "aline_eks_public_ng" {
  source = "../../../modules/aline-eks-cluster"
  infra_env = var.infra_env
  public_subnet_ids = module.aline_vpc.vpc_public_subnet_ids
  public_security_group_ids = [module.aline_vpc.security_group_public]

  public_ng_desired_size = 2
  public_ng_max_size = 4
  public_ng_min_size = 2

  public_ng_instance_type = ["t3.medium"]
  ssh_key_name = "lf-terraform-key"
  depends_on = [module.aline_vpc, module.aline_eks_cluster]
}

# module "aline_eks_private_ng" {
#   source = "../../../modules/aline-eks-cluster"
#   infra_env = var.infra_env
  # private_subnet_ids = flatten([module.aline_vpc.vpc_private_subnet_ids, module.aline_vpc.vpc_database_subnet_ids])
  # public_security_group_ids = [module.aline_vpc.security_group_public]

#   private_ng_desired_size = 2
#   private_ng_max_size = 4
#   private_ng_min_size = 2

#   private_ng_instance_type = ["t3.medium"]
#   ssh_key_name = "lf-terraform-key"
#   depends_on = [module.aline_vpc, module.aline_eks_cluster]
# }

# resource "aws_db_subnet_group" "rds_database_subnet" {
#   name = "rds-database-subnet-group"
#   subnet_ids = module.aline_vpc.vpc_database_subnet_ids
#   # subnet_ids = module.db_vpc.vpc_database_subnet_ids
# }

# module "database" {
#   source = "../../../modules/rds"

#   infra_env = var.infra_env
#   db_instance_class = var.db_instance_class
#   db_username = var.db_user
#   db_password = var.db_pass
#   aline_db_subnet_group_name = resource.aws_db_subnet_group.rds_database_subnet.name
#   depends_on = [module.aline_vpc, resource.aws_db_subnet_group.rds_database_subnet]
#   # depends_on = [module.db_vpc, resource.aws_db_subnet_group.rds_database_subnet]
# }




### to implement after we establishing peering ###
# module "db_vpc" {
#   source = "../../../modules/vpc"

#   infra_env = var.infra_env
#   vpc_cidr = var.aline_cidr
#   cidr_bits = var.aline_cidr_bits
#   az_count = var.aline_az_count
#   create_public_subnet = var.db_public_subnet
#   create_private_subnet = var.db_private_subnet
#   create_database_subnet = var.db_database_subnet
#   vpc_type = var.db_vpc_type
#   tags = merge(
#     {
#       Name = "lf-aline-${var.infra_env}-vpc"
#       Type = var.db_vpc_type
#     },
#     var.tags
#   )
# }

# ./run develop lf-aline-eks init