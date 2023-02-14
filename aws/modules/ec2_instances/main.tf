# AWS EC2 Instance Terraform Module
# EC2 Instance that will be created in VPC Public Subnet
resource "aws_instance" "ec2_public" {
  count = var.public_bool == true ? 1 : 0
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  # insert the required variables here
  name                   = "${local.name}-public"
  ami                    = data.aws_ami.app.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  # monitoring             = true
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_sg.security_group_id]
  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Create Elastic IP
# Resource - depends_on Meta-Argument
resource "aws_eip" "public_addr" {
  vpc      = true
  tags = local.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_eip_association" "eip_assoc" {
  count = var.public_bool == true ? 1 : 0
  depends_on = [ module.ec2_public, module.vpc ]
  instance = module.ec2_public.id
  allocation_id = aws_eip.public_addr.id
}

# AWS EC2 Instance Terraform Module
# EC2 Instances that will be created in VPC Private Subnets
resource "aws_instance" "ec2_private" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  # insert the 10 required variables here
  name                   = "${var.environment}-vm"
  ami                    = data.aws_ami.app.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  vpc_security_group_ids = [module.private_sg.this_security_group_id]
  #subnet_id              = module.vpc.public_subnets[0]  
  subnet_ids = [
    module.vpc.private_subnets[0],
    module.vpc.private_subnets[1]
  ]  
  instance_count         = var.private_instance_count
  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}