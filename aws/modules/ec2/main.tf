# EC2 Instance that will be created in VPC Private Subnet
module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  name                   = "${var.environment}-Private"
  #instance_count         = 5
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.pprivate_sg.security_group_id]
  tags = local.common_tags
}