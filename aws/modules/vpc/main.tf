# aws_vpc
resource "aws_vpc" "sb_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
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

# Create a policy to allow peering acceptance
resource "aws_iam_role_policy" "peering_policy" {
  name     = "vpc_peering_policy"
  role     = aws_iam_role.peer_role.id
  provider = aws.db

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:AcceptVpcPeeringConnection",
          "ec2:DescribeVpcPeeringConnections"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Create a role that can be assumed by the aline account

resource "aws_iam_role" "peer_role" {
  name     = "peer_role"
  provider = aws.db

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.aline.account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
  EOF
}

# Create a group that can accept peering connections
resource "aws_iam_group" "peering" {
  name     = "VPCPeering"
  provider = aws.aline

}

# Add members to the group
resource "aws_iam_group_membership" "peering-members" {
  name     = "VPCPeeringMembers"
  provider = aws.aline
  users = var.peering_users
  group = aws_iam_group.peering.name
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = var.destination_vpc_id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = var.region
  auto_accept   = false
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}

# Create a group policy that can assume the role in db
resource "aws_iam_group_policy" "peering-policy" {
  name     = "peering-policy"
  group    = aws_iam_group.peering.id
  provider = aws.aline

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "${aws_iam_role.peer_role.arn}"
  }
}
EOF
}