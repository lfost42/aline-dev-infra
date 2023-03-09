# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_eks" {
  name = "lambda-eks"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Add the necessary permissions to interact with the EKS cluster
  inline_policy {
    name = "eks-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "eks:DescribeCluster",
            "eks:DeleteCluster"
          ]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

# Define the Lambda function
resource "aws_lambda_function" "remove_eks_function" {
  filename      = "remove_eks.zip"
  function_name = "remove-eks"
  role          = aws_iam_role.lambda_eks.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

# Define the CloudWatch event rule to trigger the Lambda function every hour
resource "aws_cloudwatch_event_rule" "remove_eks_rule" {
  name        = "remove-eks-rule"
  description = "Remove EKS cluster"

  schedule_expression = "cron(0 * * * ? *)"  # Check every hour
}

# Define the CloudWatch event target to associate the rule with the Lambda function
resource "aws_cloudwatch_event_target" "remove_eks_target" {
  rule      = aws_cloudwatch_event_rule.remove_eks_rule.name
  arn       = aws_lambda_function.remove_eks_function.arn
  target_id = aws_lambda_function.remove_eks_function.function_name
}

# Define the Lambda function code
# data "archive_file" "remove_eks_zip" {
#   type = "zip"
#   output_path = "remove_eks.zip"
#   source_file = "remove_eks.py"
# }

