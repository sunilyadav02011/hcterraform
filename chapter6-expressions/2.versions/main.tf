terraform {
  required_version = "~> 1.0.0" {
    aws = {
      source = "hashicorp/aws"
      version = ">=4.6.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region = "us-east-1"
}