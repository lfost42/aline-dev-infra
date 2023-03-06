resource "random_string" "random" {
  length = 4
  special = false
  upper = false
}

module "aline_vpc" {
  source = "../../../modules/vpc"

  infra_env              = var.infra_env
  vpc_cidr               = var.aline_cidr
  cidr_bits              = var.aline_cidr_bits
  az_count               = var.aline_az_count
  create_public_subnet   = var.aline_public_subnet
  create_private_subnet  = var.aline_private_subnet
  create_database_subnet = var.aline_database_subnet
  vpc_type               = var.aline_vpc_type
}

resource "aws_db_subnet_group" "rds_database_subnet" {
  name       = join("-",["aline-rds-sg", random_string.random.result])
  subnet_ids = module.aline_vpc.vpc_database_subnet_ids
}

module "database" {
  source = "../../../modules/rds"

  infra_env                  = var.infra_env
  db_instance_class          = var.db_instance_class
  db_username                = var.db_user
  db_password                = var.db_pass
  aline_db_subnet_group_name = resource.aws_db_subnet_group.rds_database_subnet.name
  depends_on                 = [module.aline_vpc, resource.aws_db_subnet_group.rds_database_subnet]
}

module "eks" {
  source = "../../../modules/aline-eks-cluster"

  cluster_name = var.eks_cluster_name
  vpc_id       = module.aline_vpc.vpc_id

  cluster_subnet_ids = concat(module.aline_vpc.vpc_public_subnet_ids, module.aline_vpc.vpc_private_subnet_ids, module.aline_vpc.vpc_database_subnet_ids)
  ami_type           = var.eks_ami_type
  instance_types     = var.eks_instance_types

  private_subnets         = concat(module.aline_vpc.vpc_private_subnets, module.aline_vpc.vpc_database_subnets)
  private_ng_min_size     = var.eks_private_ng_min_size
  private_ng_max_size     = var.eks_private_ng_max_size
  private_ng_desired_size = var.eks_private_ng_desired_size

  public_subnets         = module.aline_vpc.vpc_public_subnets
  public_ng_min_size     = var.eks_public_ng_min_size
  public_ng_max_size     = var.eks_public_ng_max_size
  public_ng_desired_size = var.eks_public_ng_desired_size
}


# ./run develop aline-eks-app init