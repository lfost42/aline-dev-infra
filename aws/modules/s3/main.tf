resource "s3-bucket_object" "aline-frontend" {
  source  = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version = "3.7.0"
}