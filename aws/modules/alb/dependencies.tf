data "aws_vpc" "this" {
  tags = {
    Name = "lf-aline-${var.infra_env}-vpc"
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "shared"
    Type = "main"
  }
}

data "aws_subnet" "public" {
  Name = "lf-aline-${var.infra_env}-public-sg"
}