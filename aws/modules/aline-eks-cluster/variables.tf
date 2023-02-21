variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/19"
}

variable "cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "az_count" {
  description = "number of azs"
  type = number
  default = 2
}

variable "cluster_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "nodegroup_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "public_security_group_ids" {
  description = "list of public security group ids"
  type = list(string)
  default = [""]
}

variable "cluster_security_group_ids" {
  description = "list of cluster security group ids"
  type = list(string)
  default = [""]
}

variable "private_nodegroup_subnet_ids" {
  description = "list of private subnet ids"
  type    = list(string)
  default = [""]
}

variable "public_nodegroup_subnet_ids" {
  description = "list of public subnet ids"
  type    = list(string)
  default = [ "" ]
}

variable "public_ng_instance_type" {
  description = "public ng ec2 instance class"
  type = list(string)
  default = [""]
}

variable "private_ng_instance_type" {
  description = "private ng ec2 instance class"
  type = list(string)
  default = [""]
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

variable "cluster_name" {
  description = "version for cluster"
  type = string
  default = ""
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