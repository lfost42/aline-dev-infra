data "aws_vpc" "vpc" {
  tags = {
    Name = "lf-aline-${var.infra_env}-vpc"
  }
}

data "aws_db_subnet_group" "rds_database_subnet" {
  name = "rds-database-subnet-group"
}