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

variable db_user {
  type = string
  description = "the database user"
}

variable db_pass {
  type = string
  description = "the database password"
}