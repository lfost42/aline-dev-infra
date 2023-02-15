variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Name        = "lf-aline-${var.infra_env}"
    Project     = "lf-aline"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}