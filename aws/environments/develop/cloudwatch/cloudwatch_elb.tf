# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_elb" {
  name = "lambda-elb"
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

  # Add the necessary permissions to interact with the load balancers
  inline_policy {
    name = "load-balancer-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DeleteLoadBalancer"
          ]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

# Define the Lambda function
resource "aws_lambda_function" "remove_lb_function" {
  filename      = "remove_lb.zip"
  function_name = "remove-lb"
  role          = aws_iam_role.lambda_elb.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

# Define the CloudWatch event rule to trigger the Lambda function every hour
resource "aws_cloudwatch_event_rule" "remove_lb_rule" {
  name        = "remove-lb-rule"
  description = "Remove load balancer"

  schedule_expression = "cron(0 */12 * * ? *)"  # Check every 12 hours
}

# Associate the rule with the Lambda function
resource "aws_cloudwatch_event_target" "remove_lb_target" {
  rule      = aws_cloudwatch_event_rule.remove_lb_rule.name
  arn       = aws_lambda_function.remove_lb_function.arn
  target_id = aws_lambda_function.remove_lb_function.id
}

# Define the Lambda function code
data "archive_file" "remove_lb_zip" {
  type = "zip"
  output_path = "remove_lb.zip"
  source_file = "remove_lb.py"
}