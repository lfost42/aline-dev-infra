variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.23"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "lf-eks"
}

variable "aws_image_repository" {
  type        = string
  description = "AWS image repository for us-east-1 region" ## https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  default     = "052911266688.dkr.ecr.us-west-1.amazonaws.com"
}
