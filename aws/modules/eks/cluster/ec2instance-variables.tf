# AWS EC2 Instance Terraform Variables
# EC2 Instance Variables

# AWS EC2 Ubuntu AMI
variable "ami_id" {
  description = "AMI id"
  type = string
  default = "ami-00874d747dde814fa"  
}

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.medium"  
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key pair"
  type = string
  default = "lf-terraform-key"
}

# AWS EC2 Private Instance Count
variable "private_instance_count" {
  description = "AWS EC2 private instances count"
  type = number
  default = 2
}