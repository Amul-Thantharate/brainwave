terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 0.14"
  backend "s3" {
      bucket = "terraform-state-bucket-122"
      key = "github/project-hoobank/terraform.tfstate"
      encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}