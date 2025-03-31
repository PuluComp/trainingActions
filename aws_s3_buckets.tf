provider "aws" {
  region = "us-west-2"  # Defina a região
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "meu-bucket-s3-exemplo"  # Nome do bucket
  acl    = "private"  # ACL do bucket
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
