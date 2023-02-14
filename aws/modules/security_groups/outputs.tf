# AWS EC2 Security Group Terraform Outputs

# Public Security Group Outputs
## public_sg_group_id
output "public_sg_group_id" {
  description = "The ID of the security group"
  value       = module.public_sg.this_security_group_id
}

## public_sg_group_vpc_id
output "public_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.public_sg.this_security_group_vpc_id
}

## publicn_sg_group_name
output "publi_sg_group_name" {
  description = "The name of the security group"
  value       = module.public_sg.this_security_group_name
}

# Private EC2 Instances Security Group Outputs
## private_sg_group_id
output "private_sg_group_id" {
  description = "The ID of the security group"
  value       = module.private_sg.this_security_group_id
}

## private_sg_group_vpc_id
output "private_sg_group_vpc_id" {
  description = "The VPC ID"
  value       = module.private_sg.this_security_group_vpc_id
}

## private_sg_group_name
output "private_sg_group_name" {
  description = "The name of the security group"
  value       = module.private_sg.this_security_group_name
}