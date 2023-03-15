variable "vpc_id" {
  type        = string
  description = "cluster vpc"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "name of cluster"
  default     = ""
}

variable "cluster_version" {
  type        = string
  description = "version number of cluster"
  default     = "1.24"
}

variable "cluster_subnet_ids" {
  type        = list(string)
  description = "list of cluster subnet ids"
  default     = [""]
}

variable "ami_type" {
  type        = string
  description = "Type of ami for ec2 nodes."
  default     = "BOTTLEROCKET_x86_64"
}

variable "instance_types" {
  description = "List of instance types (sizes)."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "private_ng_desired_size" {
  description = "Desired count for private node group."
  type        = number
  default     = 2
}

variable "private_ng_max_size" {
  description = "Max count for private node group."
  type        = number
  default     = 4
}

variable "private_ng_min_size" {
  description = "Min count for private node group."
  type        = number
  default     = 2
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = any
  default     = ""
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = any
  default     = ""
}

variable "public_ng_desired_size" {
  description = "Desired count for public node group."
  type        = number
  default     = 2
}

variable "public_ng_max_size" {
  description = "Max count for public node group."
  type        = number
  default     = 4
}

variable "public_ng_min_size" {
  description = "Min count for public node group."
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
    Owner       = "lynda"
  }
}