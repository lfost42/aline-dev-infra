# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_rds" {
  name = "lambda-rds"
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

  # Add the necessary permissions to interact with the RDS instance
  inline_policy {
    name = "rds-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "rds:DescribeDBInstances",
            "rds:StopDBInstance"
          ]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

# Define the Lambda function
resource "aws_lambda_function" "deactivate_rds_function" {
  filename      = "deactivate_rds.zip"
  function_name = "deactivate-rds"
  role          = aws_iam_role.lambda_rds.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

# Define the CloudWatch event rule to trigger the Lambda function every hour
resource "aws_cloudwatch_event_rule" "deactivate_rds_rule" {
  name        = "deactivate-rds-rule"
  description = "Deactivate RDS"

  schedule_expression = "cron(0 */12 * * ? *)"  # Check every 12 hours
}

# Associate the rule with the Lambda function
resource "aws_cloudwatch_event_target" "deactivate_rds_target" {
  rule      = aws_cloudwatch_event_rule.deactivate_rds_rule.id
  arn       = aws_lambda_function.deactivate_rds_function.arn
  target_id = aws_lambda_function.deactivate_rds_function.id
  depends_on = [
    aws_cloudwatch_event_rule.deactivate_rds_rule,
    data.archive_file.deactivate_rds_zip
  ]
}

# Define the Lambda function code
data "archive_file" "deactivate_rds_zip" {
  type = "zip"
  output_path = "deactivate_rds.zip"
  source_file = "deactivate_rds.py"
}