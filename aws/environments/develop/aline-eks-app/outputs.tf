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
output "vpc_public_subnets" {
  value = module.aline_vpc.public_subnets
}
output "vpc_public_subnet_ids" {
  value = module.aline_vpc.vpc_public_subnet_ids
}
output "vpc_private_subnets" {
  value = module.aline_vpc.vpc_private_subnets
}
output "vpc_private_subnet_ids" {
  value = module.aline_vpc.vpc_private_subnet_ids
}

# output "vpc_database_subnet_blocks" {
#   value = module.aline_vpc.vpc_database_subnets_blocks
# }