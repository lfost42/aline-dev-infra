variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.23"
}

variable "aws_image_repository" {
  type        = string
  description = "AWS image repository for us-east-1 region" ## https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  default     = "052911266688.dkr.ecr.us-west-1.amazonaws.com"
}

variable "infra_env" {
  type        = string
  description = "Deployment environment name."
  default     = "dev-eks"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "dev-eks"
    ManagedBy   = "terraform"
    Owner       = "lynda"
  }
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "lf-eks"
}