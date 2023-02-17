data "aws_vpc" "vpc" {
  tags = {
    Name = "aline-${var.infra_env}-vpc"
  }
}

data "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
}