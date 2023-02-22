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