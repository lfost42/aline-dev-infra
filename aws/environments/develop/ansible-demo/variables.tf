variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "develop"
}

variable "ansible_infra_role_0" {
  type        = string
  description = "infrastructure environment"
  default     = "control-node"
}

variable "ansible_infra_role_1" {
  type        = string
  description = "infrastructure environment"
  default     = "managed-node-1"
}

variable "ansible_infra_role_2" {
  type        = string
  description = "infrastructure environment"
  default     = "managed-node-2"
}

variable "ansible_infra_role_3" {
  type        = string
  description = "infrastructure environment"
  default     = "managed-node-3"
}

variable "ansible_project" {
  type        = string
  description = "infrastructure environment"
  default     = "lf-ansible"
}

variable "ansible_key" {
  type        = string
  description = "Name of pem key."
  default     = "lf-ansible"
}

variable "region" {
  type        = string
  description = "project region"
  default     = "us-east-1"
}

variable "ansible_az_count" {
  type        = number
  description = "desired number of availability zones"
  default     = 1
}

variable "ansible_cidr" {
  type        = string
  description = "project cidr subnet block"
  default     = "10.3.0.0/18"
}

variable "ansible_cidr_bits" {
  type        = number
  description = "number of cidr bits"
  default     = 4
}

variable "ansible_public_subnet" {
  type        = bool
  description = "indicates whether to include a public subnet in the VPC"
  default     = true
}

variable "ansible_private_subnet" {
  type        = bool
  description = "indicates whether to include a private subnet in the VPC"
  default     = false
}

variable "ansible_database_subnet" {
  type        = bool
  description = "indicates whether to include a database subnet in the VPC"
  default     = false
}

variable "ansible_vpc_type" {
  type        = string
  description = "type of vpc"
  default     = "main"
}

# variable "host_ami" {
#   type        = string
#   description = "AMI of ec2 instance"
#   default     = "ami-005f9685cb30f234b" # Amazon Linux 2 
# }

variable "node1_ami" {
  type        = string
  description = "AMI of ec2 instance"
  default     = "ami-0c9978668f8d55984" # RedHat
}

variable "node2_ami" {
  type        = string
  description = "AMI of ec2 instance"
  default     = "ami-0fec2c2e2017f4e7b" # Debian
}

variable "node3_ami" {
  type        = string
  description = "AMI of ec2 instance"
  default     = "ami-0557a15b87f6559cf" # Ubuntu
}

variable "rhel_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "ansible"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
    System      = "rhel"
    User        = "ec2-user"
  }
}

variable "debian_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "ansible"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
    System      = "debian"
    User        = "admin"
  }
}

variable "ubuntu_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "ansible"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
    System      = "ubuntu"
    User        = "ubuntu"
  }
}