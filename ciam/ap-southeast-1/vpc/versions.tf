terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
  }

  backend "s3" {
    #dynamodb_table = "dynamodb-terraform-state-lock"
    bucket = "pvcb-state-s3"
    region = "ap-southeast-1"
    key    = "ciam-dev/ap-southeast-1/vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
