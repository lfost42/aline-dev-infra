# module "secrets_rotation_iam" {
#   source = "terraform-aws-modules/iam/aws"

#   create_role = true
#   role_name   = "secrets-rotation-lambda-role"

#   create_policy = true
#   policy_name   = "secrets-rotation-lambda-policy"

#   policy_description = "Policy for rotating secrets managed by AWS Secrets Manager"

#   policy_statements = [
#     {
#       Effect    = "Allow"
#       Action    = [
#         "secretsmanager:DescribeSecret",
#         "secretsmanager:GetSecretValue",
#         "secretsmanager:PutSecretValue",
#         "secretsmanager:UpdateSecretVersionStage"
#       ]
#       Resource  = values(var.secrets)
#     }
#   ]
# }