variable "infra_env" {
  description = "The infrastructure environment."
}

variable "instance_type" {
  description = "RDS instance type and size"
  default = "db.t3.micro"
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnets to join"
}

variable "vpc_id" {
  description = "The VPC to create the mysql cluster within"
}

variable "master_username" {
  description = "The master username of the mysql cluster"
}

variable "master_password" {
  description = "The master password of the mysql cluster"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Name        = "lf-aline-develop"
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}