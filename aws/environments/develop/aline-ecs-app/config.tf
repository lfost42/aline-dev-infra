terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    profile = "aline"
    region  = "us-east-1"
  }
}

provider "aws" {
  profile = var.aline_profile
  region  = var.aline_region
}

# # to create a secret
# module "secrets_rotation" {
#   source = "./modules/secrets_rotation"

#   secrets = {
#     "my_secret_1" = {
#       secret_id = aws_secretsmanager_secret.my_secret_1.id
#     },
#     "my_secret_2" = {
#       secret_id = aws_secretsmanager_secret.my_secret_2.id
#     }
#   }
# }

# variable "secrets" {
#   type = map(object({
#     secret_id = string
#   }))
# }