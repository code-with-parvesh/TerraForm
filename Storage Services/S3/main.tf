terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" // Specify the AWS region
}

// Create an S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-parvesh" // Name of the S3 bucket

  tags = {
    Name        = "My bucket" // Tag for the bucket name
    Environment = "Dev" // Tag for the environment
  }
}

// Disable S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.example.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// Set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerPreferred" // Specify the preferred ownership
  }
}

// Set bucket ACL to public-read
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "public-read" // Allow public read access
}


// Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled" // Enable versioning
  }
}

// Define a bucket policy to allow public read access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.example.id
  policy = jsonencode({ // Define the bucket policy in JSON format
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "${aws_s3_bucket.example.arn}/*",
    }],
  })
}

// Define a module for uploading template files to the bucket
module "template_files" {
  source   = "hashicorp/dir/template"
  base_dir = "${path.module}/web-files" // Base directory for template files
}

// Configure bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "web-config" {
  bucket = aws_s3_bucket.example.id // ID of the S3 bucket

  index_document {
    suffix = "index.html" // Specify the index document
  }
}

// Upload objects to the S3 bucket
resource "aws_s3_object" "Bucket_files" {
  bucket = aws_s3_bucket.example.id // ID of the S3 bucket

  for_each     = module.template_files.files // Upload each file from the module
  key          = each.key // Set the key (name) of the object
  content_type = each.value.content_type // Set the content type of the object
  source       = each.value.source_path // Set the source path of the object
  content      = each.value.content // Set the content of the object
  etag         = each.value.digests.md5 // Set the ETag of the object
}
