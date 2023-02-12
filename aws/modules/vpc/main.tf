resource "aws_vpc" "cc_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tage = {
    Name = "${var.project}-VPC"
  }
}

# Private Subnet
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "priv_subnet" {
  vpc_id = aws.vpc.cc_vpc.id
  count = var.az_count
  cidr_block = cidrsubnet(var.vpc_cidr_blick, var.subnet_cidr_bits, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-Priv-Subnet-${count.index + 1}"
  }
  depends_on = [
    aws_vpc.cc_vpc
  ]
}