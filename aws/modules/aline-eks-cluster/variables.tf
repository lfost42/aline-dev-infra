variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_id" {
  type = string
  description = "cluster vpc"
  default = ""
}

variable "cluster_name" {
  type = string
  description = "name of cluster"
  default = ""
}

variable "cluster_version" {
  type = string
  description = "version number of cluster"
  default = "1.21"
}

variable "ami_type" {
  type = string
  description = "type of ami for ec2 nodes"
  default = "BOTTLEROCKET_x86_64"
}

variable "instance_types" {
  description = "list of instance types"
  type = list(string)
  default = ["t3.medium"]
}

variable "private_subnets" {
  description = "list of private subnet"
  type    = list(string)
  default = [""]
}

variable "public_subnets" {
  description = "list of public subnets"
  type    = list(string)
  default = [ "" ]
}

variable "private_ng_desired_size" {
  description = "desired count for private ng"
  type = number
  default = 2
}

variable "private_ng_max_size" {
  description = "max count for private ng"
  type = number
  default = 4
}

variable "private_ng_min_size" {
  description = "min count for private ng"
  type = number
  default = 2
}

variable "public_ng_desired_size" {
  description = "desired count for public ng"
  type = number
  default = 2
}

variable "public_ng_max_size" {
  description = "max count for public ng"
  type = number
  default = 4
}

variable "public_ng_min_size" {
  description = "min count for public ng"
  type = number
  default = 2
}

variable "eks_cluster_version" {
  description = "version for cluster"
  type = string
  default = "1.21"
}

variable "ssh_key_name" {
  description = "ssh key name"
  type = string
  default = ""
}

variable "managed_node_group_release_version" {
  description = "node group release version"
  type = string
  default = "1.14.7-20190927"
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