# environment
infra_env = "develop"
aline_profile = "aline"

# global variables
aline_region = "us-east-1"

# db variables
# db_instance_class = "db.t3.medium"
# db_user = "admin"
# db_pass = "really_good_password" # kms rotating secret key

### ALINE VPC 
aline_cidr = "10.0.0.0/19" # 2,046 IP addresses per subnet at 6 azs
aline_cidr_bits = 8 # optimized for 6 azs
aline_az_count = 2 # us-east-1 allows up to 6 azs
aline_public_subnet = true
aline_private_subnet = true
aline_database_subnet = true

### CLUSTER VARIABLES ###
eks_cluster_name = "lf-aline-eks"
eks_ami_type = "BOTTLEROCKET_x86_64"
eks_instance_types = ["t3.micro"]

eks_private_ng_min_size     = 2
eks_private_ng_max_size     = 4
eks_private_ng_desired_size = 2

eks_public_ng_min_size     = 2
eks_public_ng_max_size     = 4
eks_public_ng_desired_size = 2

### DB VPC ###
# db_public_subnet = false
# db_private_subnet = false
# db_database_subnet = true

######### TODO #########
# vpc_name = "myvpc"
# vpc_rds_sg = "<rds security group>"
# vpc_rds_subnet = "<rds subnet group>"

# vpc_create_database_subnet_group = true 
# vpc_create_database_subnet_route_table = true   
# vpc_enable_nat_gateway = true  
# vpc_single_nat_gateway = true

# instance_size = "t3.medium"
# instance_ami = "ami-id"
# instance_root_device_size = 20
# key_pair = "lf-terraform-key"

# # EKS Node Group Variables
# desired_size = 2
# max_size = 4