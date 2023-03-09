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

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-utilization-under-10-percent-for-20-minutes"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "4"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "Alarm when CPU utilization is under 10% for 20 minutes"
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "*"
  }
  
  alarm_actions = [
    aws_lambda_function.stop_ec2_function.arn
  ]
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_ec2.name
}

resource "aws_iam_policy" "cloudwatch_event_target_policy" {
  name        = "cloudwatch-event-target-policy"
  description = "Allows CloudWatch to invoke the Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = aws_lambda_function.stop_ec2_function.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_event_target_policy_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_event_target_policy.arn
  role       = aws_iam_role.lambda_ec2.name
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
  event_pattern = jsonencode({
    source = ["aws.ec2"]
  })
}

# Associate the rule with the Lambda function
resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_rule.id
  arn       = aws_lambda_function.stop_ec2_function.arn
  target_id = aws_lambda_function.stop_ec2_function.id
  depends_on = [
    aws_cloudwatch_event_rule.stop_ec2_rule,
    data.archive_file.stop_ec2_zip
  ]

  # Add the CloudWatch alarm as a target
  input = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["running"],
      "instance-id": ["*"]
    },
    "targets": [
      {
        "id": "cpu-alarm",
        "arn": aws_cloudwatch_metric_alarm.cpu_alarm.arn
      }
    ]
  })
}

data "archive_file" "stop_ec2_zip" {
  type = "zip"
  output_path = "stop_ec2.zip"
  source_file = "stop_ec2.py"
}