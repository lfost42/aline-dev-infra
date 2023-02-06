# EC2 Instance Variables

variable "project" {
  description = "Project deployed"
  type = string
  default = "aline"
}

variable "environment" {
  description = "Environment variable used as a prefix"
  type = string
  default = "dev"
}

variable "ami" {
  description = "Ubuntu AMI"
  type = string
  default = "ami-00874d747dde814fa"  
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.medium"  
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance"
  type = string
  default = "terraform-key"
}

variable "private_instance_count" {
  description = "AWS EC2 Private Instances Count"
  type = number
  default = 2 
}