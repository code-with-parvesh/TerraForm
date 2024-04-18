terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
variable "table_name" {
  description = "Dynamodb table name"
  type = string
  default = "sneakers_table"
} 

variable "environment_name" {
  description = "Name of environment"
  default = "Sneaker_test"
}

variable "environment_type" {
  description = "Type of environment"
  default = "test"
}

resource "aws_dynamodb_table" "sneakers_table" {
  name           = var.table_name
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "BrandName"
  range_key      = "ModelNumber"

  attribute {
    name = "BrandName"
    type = "S"
  }

  attribute {
    name = "ModelNumber"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "Sneakers_GSI"
    hash_key           = "BrandName"
    range_key          = "ModelNumber"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "ALL"
  }

  tags = {
    Name        = var.environment_name
    Environment = var.environment_type
  }
}