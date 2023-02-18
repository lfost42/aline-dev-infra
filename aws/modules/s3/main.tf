resource "s3-bucket_object" "frontend" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "3.7.0"
  acl     = "private"
}