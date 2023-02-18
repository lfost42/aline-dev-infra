# Create a VPC for the region associated with the AZ
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

    tags = merge(
    {
      Name        = "aline-${var.infra_env}-vpc"
    },
    var.tags
  )
}

# Create 1 public subnets for each AZ within the regional VPC
resource "aws_subnet" "public" {
  for_each = var.public_subnet_numbers
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)
  tags = merge(
    {
      Name        = "aline-${var.infra_env}-public-subnet"
      Subnet      = "${each.key}-${each.value}"
    },
    var.tags
  )
}

# Create 1 private subnets for each AZ within the regional VPC
resource "aws_subnet" "private" {
  for_each = var.private_subnet_numbers

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = merge(
    {
      Name        = "aline-${var.infra_env}-private-subnet"
      Subnet      = "${each.key}-${each.value}"
    },
    var.tags
  )
}

# Create 1 database subnet for each AZ within the regional VPC
resource "aws_subnet" "database" {
  for_each = var.database_subnet_numbers

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  # 2,048 IP addresses each
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = merge(
    {
      Name        = "aline-${var.infra_env}-database-subnet"
      Subnet      = "${each.key}-${each.value}"
    },
    var.tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

###
# IGW and NGW
##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "aline-${var.infra_env}-igw"
      VPC         = aws_vpc.vpc.id
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
      Name        = "aline-${var.infra_env}-eip"
      VPC         = aws_vpc.vpc.id
      Role        = "private"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.private[element(keys(aws_subnet.private), 0)].id

  tags = merge(
    {
      Name        = "aline-${var.infra_env}-ngw"
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
      Name        = "aline-${var.infra_env}-public-rt"
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
      Name        = "aline-${var.infra_env}-private-rt"
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
      Name        = "aline-${var.infra_env}-database-rt"
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

# Public Route to Public Route Table for Public Subnets
resource "aws_route_table_association" "public" {
  for_each  = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id

  route_table_id = aws_route_table.public.id
}

# Private Route to Private Route Table for Private Subnets
resource "aws_route_table_association" "private" {
  for_each  = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id

  route_table_id = aws_route_table.private.id
}