# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_ec2" {
  name = "lambda-ec2"
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

  # Add the necessary permissions to interact with the EC2 instance
  inline_policy {
    name = "ec2-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:DescribeInstances",
            "ec2:StopInstances"
          ]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

# Define the Lambda function
resource "aws_lambda_function" "stop_ec2_function" {
  filename      = "stop_ec2.zip"
  function_name = "stop-ec2"
  role          = aws_iam_role.lambda_ec2.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

# Define the CloudWatch event rule to trigger the Lambda function every minute
resource "aws_cloudwatch_event_rule" "stop_ec2_rule" {
  name        = "stop-ec2-rule"
  description = "Stop EC2 instance"

  schedule_expression = "cron(0/1 * * * ? *)"  # Trigger every minute
}

# Associate the rule with the Lambda function
resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_rule.name
  arn       = aws_lambda_function.stop_ec2_function.arn
  target_id = aws_lambda_function.stop_ec2_function.id
}

# Define the Lambda function code
data "archive_file" "stop_ec2_zip" {
  type = "zip"
  output_path = "stop_ec2.zip"
  source_file = "stop_ec2.py"
}
