variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "base-infra"
}

variable "aline_region" {
  type        = string
  description = "project region"
  default     = "us-east-1"
}

variable "aline_az_count" {
  type        = number
  description = "desired number of availability zones"
  default     = 1
}

variable "aline_cidr_bits" {
  type        = number
  description = "number of cidr bits"
  default     = 4
}

variable "aline_cidr" {
  type        = string
  description = "project cidr subnet block"
  default     = "10.2.0.0/18"
}

variable "aline_public_subnet" {
  type        = bool
  description = "indicates whether to include a public subnet in the VPC"
  default     = true
}

variable "aline_private_subnet" {
  type        = bool
  description = "indicates whether to include a private subnet in the VPC"
  default     = true
}

variable "aline_database_subnet" {
  type        = bool
  description = "indicates whether to include a database subnet in the VPC"
  default     = true
}

variable "aline_vpc_type" {
  type        = string
  description = "type of vpc"
  default     = "main"
}

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default = {
#     Project     = "lf-aline"
#     Environment = "develop"
#     ManagedBy   = "terraform"
#     Owner       = "lynda"
#   }
# }


### enable once peering is established ###
# variable "db_public_subnet" {
#   type = bool
#   description = "indicates whether to include a public subnet in the VPC"
#   default = false
# }

# variable "db_private_subnet" {
#   type = bool
#   description = "indicates whether to include a private subnet in the VPC"
#   default = false
# }

# variable "db_database_subnet" {
#   type = bool
#   description = "indicates whether to include a database subnet in the VPC"
#   default = true
# }

# variable "db_vpc_type" {
#   type = string
#   description = "type of vpc"
#   default = "database"
# }