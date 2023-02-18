variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_bucket_prefix" {
  type    = string
  default = "lf-aline-tfstate"
}

variable "aws_dynamodb_table" {
  type    = string
  default = "lf-aline-tflock"
}

variable "full_access_users" {
  type    = list(string)
  default = []

}

variable "read_only_users" {
  type    = list(string)
  default = []
}