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
  profile = "terraform-user"
}

variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "account_id" {
  description = "AWS Account ID"
  # You can either provide the account ID here or dynamically fetch it using data sources or environment variables if needed
  default     = "YOUR_ACCOUNT_ID"
}

###################
### API Gateway ###
###################
resource "aws_api_gateway_rest_api" "book-api" {
  name = "Book REST API"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.book-api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.book-api.id
}

resource "aws_api_gateway_method" "get-method" {
  rest_api_id   = aws_api_gateway_rest_api.book-api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.book-api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get-method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.book-lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "book-api-deployment" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.book-api.id
  stage_name  = "dev"
}

###############
### Lambdas ###
###############
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.book-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.book-api.execution_arn}/*/*"
}

resource "aws_iam_role" "book-lambda-role" {
  name = "lambda_dynamodb_role"

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

   resource "aws_iam_policy" "get-books-log-policy" {
     name = "get-books-logging-policy"
     policy = jsonencode({
       Version = "2012-10-17",
       Statement = [
         {
           Action = [
             "logs:CreateLogStream",
             "logs:PutLogEvents"
           ],
           Effect = "Allow",
           Resource = "arn:aws:logs:*:*:*"
         }
       ]
     })
   }

   resource "aws_iam_role_policy_attachment" "get-books-log-policy-attachment" {
     role = aws_iam_role.book-lambda-role.id
     policy_arn = aws_iam_policy.get-books-log-policy.arn
   }

resource "aws_lambda_function" "book-lambda" {
  function_name = "get_book_lambda"
  handler       = "get_books.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.book-lambda-role.arn
  filename      = "./output/get_books.zip"

  # Introduce a change to trigger updates
  source_code_hash = filebase64sha256("${path.module}/output/get_books.zip")
}

resource "aws_cloudwatch_log_group" "book-lambda-logs" {
  name              = "/aws/lambda/${aws_lambda_function.book-lambda.function_name}"
  retention_in_days = 30  # Set retention period for logs, adjust as needed
}

data "archive_file" "zip_lambda" {
  type = "zip"
  source_dir = "${path.module}/src"
  output_path = "${path.module}/output/get_books.zip"

}

################
### DynamoDB ###
################
resource "aws_dynamodb_table" "books-table" {
  name           = "books_table"
  hash_key       = "title"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "title"
    type = "S"
  }
}