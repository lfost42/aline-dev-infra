data "aws_vpc" "vpc" {
  tags = {
    Name = "lf-aline-${var.infra_env}-vpc"
    Type = "main"
  }
}