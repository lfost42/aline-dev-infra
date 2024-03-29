variable "project" {
  type        = string
  description = "infrastructure environment"
  default     = "lf-aline"
}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "infra_role" {
  type        = string
  description = "infrastructure purpose"
}

variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t3.micro"
}

variable "instance_ami" {
  type        = string
  description = "Server image to use"
  default     = "ami-005f9685cb30f234b" # Amazon Linux 2 AMI
}

variable "key_name" {
  type        = string
  description = "Name of aws pem key used to log into instance."
  default     = ""
}

variable "instance_root_device_size" {
  type        = number
  description = "Root bock device size in GB"
  default     = 10
}

variable "subnet" {
  type        = string
  description = "valid subnets to assign to server"
  default     = ""
}

variable "security_groups" {
  type        = list(string)
  description = "security groups to assign to server"
  default     = []
}

variable "create_eip" {
  type        = bool
  default     = false
  description = "whether or create an EIP for the ec2 instance or not"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "ansible"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
  }
}