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

resource "aws_dynamodb_table" "my-table" {
  name           = "dev-my-table"
  hash_key       = "title"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "title"
    type = "S"
  }
}