# environment
infra_env    = "develop"
aline_region = "us-east-1"

# ### DB RDS
db_instance_class = "db.t3.medium"
db_user           = "admin"

### ALINE VPC 
aline_cidr            = "10.0.0.0/18" # ~1,022 IP addresses per subnet at 5 azs
aline_cidr_bits       = 4             # produces subnets with /22 subnet mask
aline_az_count        = 2             # may scale up to 5 azs
aline_public_subnet   = true
aline_private_subnet  = true
aline_database_subnet = true

# # ### CLUSTER VARIABLES ###
eks_cluster_name    = "lf-aline-eks"
eks_cluster_version = "1.21"
eks_ami_type        = "BOTTLEROCKET_x86_64"
eks_instance_types  = ["t3.medium"]

eks_private_ng_min_size     = 2
eks_private_ng_max_size     = 4
eks_private_ng_desired_size = 2

eks_public_ng_min_size     = 1
eks_public_ng_max_size     = 3
eks_public_ng_desired_size = 1

# ### DATABASE VPC 
# db_public_subnet   = false
# db_private_subnet  = false
# db_database_subnet = true
