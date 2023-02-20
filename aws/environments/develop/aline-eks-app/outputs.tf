output "vpc_id" {
  value = module.aline_vpc.vpc_id
}

output "vpc_cidr" {
  value = module.aline_vpc.vpc_cidr
}

# output "vpc_public_subnets" {
#   value = {
#     for subnet in module.aline_vpc.aws_subnet.public :
#     subnet.id => subnet.cidr_block
#   }
# }

# output "vpc_private_subnets" {
#   value = {
#     for subnet in module.aline_vpc.aws_subnet.private :
#     subnet.id => subnet.cidr_block
#   }
# }

# output "vpc_database_subnets" {
#   value = {
#     for subnet in module.aline_vpc.aws_subnet.database :
#     subnet.id => subnet.cidr_block
#   }
# }

# output "vpc_database_subnet_ids" {
#   value = [for subnet in module.aline_vpc.aws_subnet.database : subnet.id]
# }

# output "security_group_public" {
#   value = module.aline_vpc.aws_security_group.public.id
# }

# output "security_group_private" {
#   value = module.aline_vpc.aws_security_group.private.id
# }
