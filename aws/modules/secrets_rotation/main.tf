# module "secrets_rotation_lambda" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name = "my-rotation-lambda"
#   description   = "Lambda function for rotating secrets"
#   handler       = "index.handler"
#   runtime       = "python3.8"
#   filename      = "rotation_lambda.zip"

#   environment_variables = {
#     SECRETS = jsonencode(var.secrets)
#   }

#   # Reference to the IAM role created in the IAM module
#   role = module.secrets_rotation_iam.role_arn

#   # Reference to the IAM policy created in the IAM module
#   policy = module.secrets_rotation_iam.policy_arn

#   # Other Lambda configuration options omitted for brevity
# }