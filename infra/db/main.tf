provider "aws" {
  region = "us-east-1"
}

# S3 bucket for uploads
resource "aws_s3_bucket" "amadeus_uploads" {
  bucket = "amadeus-uploads"
  acl    = "private"
}

# SNS topic for upload-review notifications
resource "aws_sns_topic" "upload_review" {
  name = "upload-review"
}

# DynamoDB table for uploads
resource "aws_dynamodb_table" "uploads" {
  name           = "uploads"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  # Additional attributes like userId, status could use sparse indexing if needed
}

# DynamoDB table for review queue
resource "aws_dynamodb_table" "reviews" {
  name           = "reviews"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
  # Additional attributes like uploadId, status can be stored in JSON or additional fields
}
