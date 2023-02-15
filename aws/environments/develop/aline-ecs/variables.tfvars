infra_env = "develop"

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Name        = "lf-aline-develop"
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}