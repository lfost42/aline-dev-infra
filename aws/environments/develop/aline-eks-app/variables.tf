variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "develop"
}

variable "aline_region" {
  type        = string
  description = "project region"
  default     = "us-east-1"
}

variable "db_instance_class" {
  type        = string
  description = "instance class(type) for the rds database"
  default     = "db.t3.medium"
}

variable "db_user" {
  type        = string
  description = "master username for the rds database"
  default     = "admin"
}

variable "db_pass" {
  type        = string
  description = "password for the rds database"
  default     = "kms_rotating_secret_key"
}

variable "aline_az_count" {
  type        = number
  description = "desired number of availability zones"
  default     = 2
}

variable "aline_cidr_bits" {
  type        = number
  description = "number of cidr bits"
  default     = 5
}

variable "aline_cidr" {
  type        = string
  description = "project cidr subnet block"
  default     = "10.0.0.0/17"
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

variable "eks_cluster_name" {
  type        = string
  description = "name of cluster"
  default     = ""
}

variable "eks_cluster_version" {
  type        = string
  description = "eks cluster version"
  default     = "1.21"
}

variable "eks_ami_type" {
  type        = string
  description = ""
  default     = ""
}
variable "eks_instance_types" {
  type        = list(string)
  description = ""
  default     = [""]
}

variable "eks_private_ng_min_size" {
  type        = string
  description = ""
  default     = ""
}
variable "eks_private_ng_max_size" {
  type        = string
  description = ""
  default     = ""
}
variable "eks_private_ng_desired_size" {
  type        = string
  description = ""
  default     = ""
}

variable "eks_public_ng_min_size" {
  type        = string
  description = ""
  default     = ""
}
variable "eks_public_ng_max_size" {
  type        = string
  description = ""
  default     = ""
}
variable "eks_public_ng_desired_size" {
  type        = string
  description = ""
  default     = ""
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

# variable "public_ec2_instance_size" {
#   type = string
#   description = "instance size for public ec2"
#   default = "t3.small"
# }

# variable "private_ec2_instance_size" {
#   type = string
#   description = "instance size for private ec2"
#   default = "t3.medium"
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