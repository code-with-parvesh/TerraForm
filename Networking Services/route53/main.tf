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
resource "aws_route53_zone" "example_zone" {
  name = "exampleeeeeeeeeeee.com"
}
resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "www.example.com" # add your desired domain name
  type    = "A"
  ttl     = "300"
  records = ["1.2.3.4"]
}