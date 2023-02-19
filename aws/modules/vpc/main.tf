# ./run develop aline-eks-app init
# Create a VPC for the region associated with the AZ
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-vpc"
    },
    var.tags
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create 1 public subnets for each AZ within the regional VPC
resource "aws_subnet" "public" {
  vpc_id  = aws_vpc.vpc.id

  count   = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, var.cidr_bits, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-public-subnet-${count.index+1}"
    },
    var.tags
  )
}

# Create 1 private subnets for each AZ within the regional VPC
resource "aws_subnet" "private" {
  vpc_id  = aws_vpc.vpc.id

  count   = var.az_count
  # offsets the position of the subnet within the VPC's range to avoid cidr block collisions
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, var.cidr_bits, count.index + (var.az_count * 2))
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-private-subnet-${count.index+1}"
    },
    var.tags
  )
}

# Create 1 database subnet for each AZ within the regional VPC
resource "aws_subnet" "database" {
  vpc_id  = aws_vpc.vpc.id

  count   = var.az_count
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, var.cidr_bits, count.index + (var.az_count * 3))
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-database-subnet-${count.index+1}"
    },
    var.tags
  )
}

###
# IGW and NGW
##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-igw"
      VPC         = aws_vpc.vpc.id
      Role        = "public"
    },
    var.tags
  )
}

resource "aws_eip" "nat" {
  vpc = true

  lifecycle {
    # prevent_destroy = true
  }

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-eip"
      VPC         = aws_vpc.vpc.id
      Role        = "private"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.private[0].id

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-ngw"
      VPC         = aws_vpc.vpc.id
      Role        = "private"
    },
    var.tags
  )
}

# Public Route Table (Subnets with IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-public-rt"
      VPC         = aws_vpc.vpc.id
      Role        = "public"
    },
    var.tags
  )
}

# Private Route Tables (Subnets with NGW)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-private-rt"
      VPC         = aws_vpc.vpc.id
      Role        = "private"
    },
    var.tags
  )
}

# Database Route Tables (Subnets with NGW)
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "lf-aline-${var.infra_env}-database-rt"
      VPC         = aws_vpc.vpc.id
      Role        = "database"
    },
    var.tags
  )
}

# Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Private Route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# Database Route
resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# Public Route to Public Route Table for Public Subnets
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id
}

# Private Route to Private Route Table for Private Subnets
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.private.id
}

# Database Route to Database Route Table for Database Subnets
resource "aws_route_table_association" "database" {
  count          = var.az_count
  subnet_id      = aws_subnet.database[count.index].id

  route_table_id = aws_route_table.database.id
}