output "vpc_id" {
  value = module.aline_vpc.vpc_id
}
output "vpc_cidr" {
  value = module.aline_vpc.vpc_cidr
}
output "vpc_public_subnets" {
  value = module.aline_vpc.vpc_public_subnets
}
output "vpc_private_subnet_ids" {
  value = module.aline_vpc.vpc_private_subnet_ids
}
output "vpc_database_subnet" {
  value = module.aline_vpc.vpc_database_subnets
}