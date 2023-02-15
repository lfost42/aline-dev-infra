resource "aws_rds_cluster_parameter_group" "paramater_group" {
  name   = "aline-${var.infra_env}-pg-mysql-cluster"
  family = "mysql-mysql8.0"

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
    Type        = "mysql"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  # Name is used in aws_rds_cluster::db_parameter_group_name parameter
  name   = "aline-${var.infra_env}-mysql"
  family = "mysql-mysql8.0"

  tags = {
    Name        = "aline ${var.infra_env} RDS Parameter Group - mysql"
    Type        = "mysql"
  }
}

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

  username = var.master_username
  password = var.master_password

  tags = {
    Type        = "mysql"
  }
}

