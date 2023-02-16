# variable "domain_name" {
#   type        = string
#   description = "alinefinancial.com"
# }

# variable "bucket_name" {
#   type        = string
#   description = "The name of the bucket without the www. prefix. Normally domain_name."
# }

# variable "common_tags" {
#   description = "Common tags you want applied to all components."
# }

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default = {
#     Project     = "lf-aline"
#     Environment = "develop"
#     ManagedBy   = "terraform"
#   }
# }