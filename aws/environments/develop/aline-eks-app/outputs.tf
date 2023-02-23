output "vpc_id" {
  value = module.aline_vpc.vpc_id
}

output "vpc_cidr" {
  value = module.aline_vpc.vpc_cidr
}

output "vpc_database_subnets" {
  value = module.aline_vpc.vpc_database_subnets
}

output "vpc_database_subnet_ids" {
  value = module.aline_vpc.vpc_database_subnet_ids
}

output "vpc_database_subnet_blocks" {
  value = module.aline_vpc.vpc_database_subnets_blocks
}

resource "aws_db_subnet_group" "rds_database_subnet" {
  name = "rds-database-subnet-group"
  subnet_ids = module.aline_vpc.vpc_database_subnet_ids
}