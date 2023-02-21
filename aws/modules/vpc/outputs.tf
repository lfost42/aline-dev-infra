output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_public_subnets" {
  value = aws_subnet.public
}

output "vpc_private_subnets" {
  value = aws_subnet.private
}

output "vpc_database_subnets" {
  value = aws_subnet.database
}

output "vpc_public_subnet_blocks" {
  value = {
    for subnet in aws_subnet.public :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_private_subnets_blocks" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.private :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_database_subnets_blocks" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.database :
    subnet.id => subnet.cidr_block
  }
}

output "vpc_public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "vpc_private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "vpc_database_subnet_ids" {
  value = [for subnet in aws_subnet.database : subnet.id]
}

output "security_group_public" {
  value = aws_security_group.public.id
}

output "security_group_private" {
  value = aws_security_group.private.id
}
