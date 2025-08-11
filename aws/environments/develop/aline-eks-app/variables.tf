variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "infra_env" {
  type        = string
  description = "Deployment environment name."
  default     = "develop"
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

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "lf-eks"
}

variable "eks_node_groups" {
  type        = map(any)
  description = "A map of objects representing the EKS managed node groups."
  default = {
    public_node = {
      ami_type       = "BOTTLEROCKET_x86_64"
      platform       = "bottlerocket"
      min_size       = 1
      max_size       = 4
      desired_size   = 1
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      disk_size      = 10
      labels = {
        subnet = "public"
      }
      bootstrap_extra_args = <<-EOT
      # extra args added
      [settings.kernel]
      lockdown = "integrity"
      EOT
    }
  }
}