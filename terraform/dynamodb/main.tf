variable "table_name" {
 description = "The name of the DynamoDB table"
 type    = string
}
resource "aws_dynamodb_table" "books-table" {
  name           = var.table_name
  hash_key       = "title"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "title"
    type = "S"
  }
}