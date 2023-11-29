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