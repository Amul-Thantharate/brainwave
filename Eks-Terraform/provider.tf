terraform {
    required_providers {
        eks = {
        source  = "hashicorp/eks"
        version = "0.21.0"
        }
    }
    required_version = ">= 0.13"
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