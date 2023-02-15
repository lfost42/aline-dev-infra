# environment
infra_env = "develop"

# EKS Provider variables
aws_region = "us-east-1"

# VPC Variables
vpc_name = "myvpc"
vpc_cidr = "10.0.0.0/16"
subnet_cidr_bits = 8
azs = ["us-east-1a", "us-east-1b"]
vpc_public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]
vpc_rds_sg = "<rds security group>"
vpc_rds_subnet = "<rds subnet group>"

vpc_create_database_subnet_group = true 
vpc_create_database_subnet_route_table = true   
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true

instance_size = "t3.medium"
instance_ami = "ami-id"
instance_root_device_size = 20
key_pair = "lf-terraform-key"

# EKS Node Group Variables
desired_size = 2
max_size = 4

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Name        = "lf-aline-develop"
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}