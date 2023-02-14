# DATA SOURCES
data "aws_caller_identity" "aline" {
  provider = aws.aline
}

data "aws_caller_identity" "db" {
  provider = aws.db
}

data "aws_caller_identity" "peer" {
  provider = aws.peer
}