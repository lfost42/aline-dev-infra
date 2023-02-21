output "vpc_id" {
  value = module.aline_vpc.vpc_id
}

output "vpc_cidr" {
  value = module.aline_vpc.vpc_cidr
}

output "security_group_public" {
  value = module.aline_vpc.vpc_public_subnet_ids
}

output "security_group_private" {
  value = module.aline_vpc.vpc_private_subnet_ids
}

output "vpc_database_subnet_ids" {
  value = module.aline_vpc.vpc_database_subnet_ids
}

output "vpc_database_subnets" {
  value = module.aline_vpc.vpc_database_subnets
}

output "vpc_database_subnet_blocks" {
  value = module.aline_vpc.vpc_database_subnets_blocks
}