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
 

resource "aws_instance" "my_vm" {
    ami = "ami-09d56f8956ab235b3"
    instance_type ="t2.micro"
  
 

  tags = {
   Name = "My EC2 instance"
 }
}