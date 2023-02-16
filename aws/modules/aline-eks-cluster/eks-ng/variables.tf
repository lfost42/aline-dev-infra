variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}