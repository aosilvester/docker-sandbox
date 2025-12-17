terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3      = "http://localstack:4566"
    lambda  = "http://localstack:4566"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-local-bucket"
}


# Automatically create function.zip
resource "null_resource" "zip_lambda" {
  triggers = {
    lambda_src = filemd5("../lambda/my_lambda/lambda_function.py")
    lambda_reqs = filemd5("../lambda/my_lambda/requirements.txt")

  }

  provisioner "local-exec" {
    command = "cd ../lambda/my_lambda && zip -r function.zip lambda_function.py"
  }
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {
  depends_on    = [null_resource.zip_lambda]   # ensure zip is created first
  function_name = "my-local-lambda"
  filename      = "../lambda/my_lambda/function.zip"
  handler       = "lambda_function.handler"
  runtime       = "python3.10"
  role          = "arn:aws:iam::000000000000:role/lambda-ex"
}