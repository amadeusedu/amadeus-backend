terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = var.state_bucket
    key            = "gateway/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.lock_table
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.tags
  }
}
