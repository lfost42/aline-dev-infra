# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default = {
#     Project     = "lf-aline"
#     Environment = "develop"
#     ManagedBy   = "terraform"
#   }
# }

infra_env = "develop"
aline_azs = ["us-east-1a", "us-east-1b"]
aline_cidr = "10.0.0.0/17"
aline_public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 2)
aline_private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 2, 4)
aline_database_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)