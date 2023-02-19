data "aws_vpc" "vpc" {
  tags = {
    Name = "lf-aline-${var.infra_env}-vpc"
    ### add after peering is established ###
    # Type = "database"
  }
}