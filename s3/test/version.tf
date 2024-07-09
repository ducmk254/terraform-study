terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }

  # ##  Used for end-to-end testing on project; update to suit your needs
  # backend "s3" {
  #   bucket         = "pvcb-terraform-state-s3"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "dynamodb-terraform-state-lock"
  #   key            = "udnt-dev/ap-southeast-1/s3/block-funds/terraform.tfstate"
  #   access_key     = "AKIAZDJT7CGCBPXBYVLT"
  #   secret_key     = "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"
  #   role_arn       = "arn:aws:iam::413432878807:role/CrossAccountTerraformS3"
  # }
}

provider "aws" {
  region = local.region
}