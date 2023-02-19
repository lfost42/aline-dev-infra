variable "aline_profile" {
  type = string
  description = "aws profile"
  default = "aline"
}

variable "infra_env" {
  type = string
  description = "infrastructure environment"
  default = "develop"
}

variable "aline_region" {
  type = string
  description = "project region"
  default = "us-east-1"
}

variable "aline_az_count" {
  type = number
  description = "desired number of availability zones"
  default = 2
}

variable "aline_cidr_bits" {
  type = number
  description = "number of cidr bits"
  default = 8
}

variable "aline_cidr" {
  type = string
  description = "project cidr subnet block"
  default = "10.0.0.0/17"
}

variable "public_ec2_instance_size" {
  type = string
  description = "instance size for public ec2"
  default = "t3.small"
}

variable "private_ec2_instance_size" {
  type = string
  description = "instance size for private ec2"
  default = "t3.medium"
}

variable "db_instance_class" {
  type = string
  description = "instance class(type) for the rds database"
  default = "db.t3.medium"
}

variable "db_user" {
  type = string
  description = "master username for the rds database"
  default = "admin"
}

variable "db_pass" {
  type = string
  description = "password for the rds database"
  default = "really_good_password" # override with kms rotating secret key
}
