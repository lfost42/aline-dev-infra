# variable "db_user" {
#   type = string
#   description = "rds master username"
#   default = "admin"
# }
# variable "db_pass" {
#   type = string
#   description = "rds master password"
#   default = "really_good_password" # override with kms rotating secret key
# }

infra_env = "develop"
aline_azs = ["us-east-1a", "us-east-1b"]
aline_cidr = "10.0.0.0/17"
aline_public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 2)
aline_private_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 2, 4)
aline_database_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)

db_instance_class = "db.t3.medium"
db_username = "admin"
db_password = "really_good_password" # override with kms rotating secret key