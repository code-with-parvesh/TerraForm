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
 #########################
## Redshift IAM - Main ##
#########################

# Define input variables with default values
variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "myapp"
}

variable "app_environment" {
  description = "Environment of the application"
  type        = string
  default     = "dev"
}

# Create an IAM Role for Redshift
resource "aws_iam_role" "redshift-role" {
  name = "${var.app_name}-${var.app_environment}-redshift-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-role"
    Environment = var.app_environment
  }
}

# Create and assign an IAM Role Policy to access S3 Buckets
resource "aws_iam_role_policy" "redshift-s3-full-access-policy" {
  name = "${var.app_name}-${var.app_environment}-redshift-role-s3-policy"
  role = aws_iam_role.redshift-role.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  })
}
# Create a Redshift Cluster
resource "aws_redshift_cluster" "example" {
  cluster_identifier   = "example-cluster"
  node_type            = "dc2.large"
  cluster_type         = "single-node"
  master_username      = "masteruser"
  master_password      = "Password123"
  iam_roles            = [aws_iam_role.redshift-role.arn]  # Assuming you want to attach the IAM role created above
  publicly_accessible  = true  # Set to true if you want the cluster to be accessible publicly, false otherwise
  skip_final_snapshot  = true  # Set to true if you don't want a final snapshot to be created when the cluster is deleted
}