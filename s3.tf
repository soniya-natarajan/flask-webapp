provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-s3-bucket11"
  acl    = "private"
tags = {
    Name        = "My S3 Bucket"
    Environment = "Dev"
  }
}
