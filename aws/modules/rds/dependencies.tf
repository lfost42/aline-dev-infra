data "aws_vpc" "vpc" {
  tags = {
    Name        = "cloudcasts-${var.infra_env}-vpc"
  }
}

data "aws_subnet_ids" "database_subnets" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name        = "lf-aline-${var.infra_env}-vpc"
  }
}
