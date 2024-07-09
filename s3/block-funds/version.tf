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
  #   bucket         = "ducmk254-terraform-state-s3"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "dynamodb-terraform-state-lock"
  #   key            = "abcd-dev/ap-southeast-1/s3/block-funds/terraform.tfstate"
  #   demo_access_key     = ""
  #   demo_secret_key     = ""
  #   role_arn       = "arn:aws:iam::413432xxxxxx:role/CrossAccountTerraformS3"
  # }
}

provider "aws" {
  region = local.region
}