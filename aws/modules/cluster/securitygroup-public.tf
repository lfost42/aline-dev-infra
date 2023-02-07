# Security Group for Public EC2
module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name = "public-sg"
  description = "Security Group with SSH port open, egress ports open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags
}
