terraform {
    required_version = ">= 0.12"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 3.0"
        }
    }
}
provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "terraform-state-bucket-122"
        key    = "Brainwave/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
    }
}