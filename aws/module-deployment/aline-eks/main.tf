# Project
project_var = "EKS-Base-Infrastructure"

# Provider Info
aws_region = "us-east-1"
app_id_var = "aline"

# VPC
az_count = "1"
subnet_cidr_bits = "8"
ec2_type = "t2.medium"
def_vpc_id = "<vpc id>"
def_vpc_cidr_block = "<cidr block address>"
def_vpc_rds_subnet_id = "<subnet id>"
def_rds_sg_id = "<rds sg id>"
def_vpc_rds_instance_class = "<instance-type>"
def_vpc_rds_instance_identifier = "<name>"
ec2_az = "<nodegroup az>"
key-pair = "pem"

# EKS Node Group Variables
desired_size = 2
max_size = 10

