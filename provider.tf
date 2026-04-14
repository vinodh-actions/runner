terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }

  backend "s3" {
    bucket  = "latest-vinodh-remote-state-dev"
    key     = "roboshop-dev-runner"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}