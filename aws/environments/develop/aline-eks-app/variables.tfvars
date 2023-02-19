# environment
infra_env = "develop"
aline_profile = "aline"

# global variables
aline_region = "us-east-1"

# db variables
db_instance_class = "db.t3.medium"
db_username = "" # kms rotating secret key

# VPC Variables
aline_cidr = "10.0.0.0/17" # /17 provides a range of 32 subnets
aline_cidr_bits = 9
aline_az_count = 2

######### TODO #########
vpc_name = "myvpc"
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