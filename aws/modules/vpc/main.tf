# Uses VPC community module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "aline-${var.infra_env}-vpc"
  cidr = var.vpc_cidr
  azs = var.azs

  # Single NAT Gateway, see docs linked above
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

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

###
# IGW and NGW
##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "aline-${var.infra_env}-vpc"
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
  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id

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