variable "infra_env" {
  description = "The infrastructure environment."
  type = string
}

variable "db_instance_class" {
  description = "RDS instance type and size"
  type = string
  default = "db.t3.micro"
}

variable "db_username" {
  type = string
  description = "The master username of the mysql cluster"
  default = "admin"
}

variable "db_password" {
  type = string
  description = "The master password of the mysql cluster"
  default = "really_good_password" # overwrite with KMS rotating secret
}

variable "vpc_id" {
  type = string
  description = "The master password of the mysql cluster"
}

variable "database_subnets" {
  type = list(string)
  description = "The master password of the mysql cluster"
  default = [""]
}

variable "db_parameter_group_name" {
  type = string
  description = "parameter group name"
  default = "default.mysql8.0"
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}