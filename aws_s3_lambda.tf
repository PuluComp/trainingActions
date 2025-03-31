provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "lambda_bucket" {
  acl = "private"

  tags = {
    Environment = "Dev"
    Name        = "Lambda Bucket"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  # Upload your deployment package to the S3 bucket
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = "path/to/lambda_deploy_package.zip"

  tags = {
    Environment = "Dev"
    Name        = "My Lambda Function"
  }
}

output "lambda_function_name" {
  value = aws_lambda_function.my_lambda.function_name
}
