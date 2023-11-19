terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_iam_role" "my_lambda_role" {
  name = "dev_lambda_dynamodb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "dev_my_lambda"
  handler       = "event-lambda.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.my_lambda_role.arn
  filename      = "./src/event-lambda.zip"
}

data "archive_file" "zip_lambda" {
  type = "zip"
  source_dir = "${path.module}/src"
  output_path = "${path.module}/src/event-lambda.zip"

}