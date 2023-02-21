# environment
infra_env     = "develop"
aline_profile = "aline"
aline_region  = "us-east-1"

### DB RDS
db_instance_class = "db.t3.medium"
db_user           = "admin"

### ALINE VPC 
aline_cidr            = "10.0.0.0/19" # 2,046 IP addresses per subnet at 6 azs
aline_cidr_bits       = 8 # optimized for 6 azs
aline_az_count        = 2 # us-east-1 allows up to 6 azs
aline_public_subnet   = true
aline_private_subnet  = true
aline_database_subnet = true

# ### CLUSTER VARIABLES ###
eks_cluster_name   = "lf-aline-eks"
eks_ami_type       = "BOTTLEROCKET_x86_64"
eks_instance_types = ["t3.micro"]

eks_private_ng_min_size     = 2
eks_private_ng_max_size     = 4
eks_private_ng_desired_size = 2

eks_public_ng_min_size     = 2
eks_public_ng_max_size     = 4
eks_public_ng_desired_size = 2