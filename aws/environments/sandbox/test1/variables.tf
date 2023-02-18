variable "aline_profile" {
  type = string
  description = "aws profile"
  default = "aline"
}

variable "infra_env" {
  type = string
  description = "infrastructure environment"
  default = "sandbox"
}

variable "aline_region" {
  type = string
  description = "project region"
  default = "us-east-1"
}