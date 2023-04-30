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
