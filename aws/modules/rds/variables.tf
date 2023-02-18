variable "infra_env" {
  description = "The infrastructure environment."
  type = string
}

variable "db_allocated_storage" {
  type = number
  description = "allocated storage in GiB"
  default = 10
}

variable "db_name" {
  type = string
  description = "default name for database"
  default = "alinedb"
}

variable "db_engine" {
  type = string
  description = "engine for MySQL RDS"
  default = "mysql"
}

variable "db_engine_version" {
  type = string
  description = "engine for MySQL RDS"
  default = "8.0.28"
}

variable "db_instance_class" {
  description = "RDS instance type and size"
  type = string
  default = "db.t3.micro"
}

variable "db_username" {
  type = string
  description = "The master username of the mysql cluster"
  # default = "admin"
}

variable "db_password" {
  type = string
  description = "The master password of the mysql cluster"
  default = "really_good_password" # overwrite with KMS rotating secret
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