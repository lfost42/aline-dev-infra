module "ec2_public" {
  source = "../../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "public"
  instance_size = var.public_ec2_instance_size
  instance_ami = data.aws_ami.ubuntu.id
  subnets = keys(module.vpc.vpc_public_subnets)
  security_groups = [module.vpc.security_group_public]
  create_eip = true
}

module "ec2_private" {
  source = "../../../modules/ec2"

  infra_env = var.infra_env
  infra_role = "private"
  instance_size = var.private_ec2_instance_size
  instance_ami = data.aws_ami.ubuntu.id
  instance_root_device_size = 20
  subnets = keys(module.vpc.vpc_private_subnets)
  security_groups = [module.vpc.security_group_private]
  create_eip = false
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = module.vpc.vpc_database_subnet_ids
}

module "database" {
  source = "../../../modules/rds"

  infra_env = var.infra_env
  db_instance_class = var.db_instance_class
  db_username = var.db_user
  db_password = var.db_pass
  depends_on = [module.vpc, resource.aws_db_subnet_group.rds-private-subnet]
}

module "vpc" {
  source = "../../../modules/vpc"

  infra_env = var.infra_env
  vpc_cidr = var.aline_cidr
}