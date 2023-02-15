resource "aws_rds_cluster_parameter_group" "paramater_group" {
  name   = "aline-${var.infra_env}-pg-mysql-cluster"
  family = "mysql-mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
  }

  tags = {
    Name        = "aline ${var.infra_env} RDS Parameter Group - mysql Cluster"
    Environment = var.infra_env
    Project     = "aline"
    ManagedBy   = "terraform"
    Type        = "mysql"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  # Name is used in aws_rds_cluster::db_parameter_group_name parameter
  name   = "aline-${var.infra_env}-mysql"
  family = "mysql-mysql5.7"

  tags = {
    Name        = "aline ${var.infra_env} RDS Parameter Group - mysql"
    Environment = var.infra_env
    Project     = "aline"
    ManagedBy   = "terraform"
    Type        = "mysql"
  }
}

# aws database subnet group
# aws rds cluster
# aws rds cluster instance
module "rds-mysql" {
  source  = "terraform-aws-modules/rds/aws//modules/db_instance"
  version = "5.4.2"
  # insert the 12 required variables here

  name           = "aline-${var.infra_env}-mysql"
  engine         = "mysql"
  preferred_versions = ["8.0.27", "8.0.26"]
  instance_type  = var.instance_type

  vpc_id  = var.vpc_id
  subnets = var.subnets

  replica_count           = 1

  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.paramater_group.name

  create_random_password = false
  username = var.master_username
  password = var.master_password

  tags = {
    Environment = var.infra_env
    Project     = "aline"
    ManagedBy   = "terraform"
    Type        = "mysql"
  }
}

