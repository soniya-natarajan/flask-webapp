provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-s3-bucket"
  acl    = "private"
tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}
