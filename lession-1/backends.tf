terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = ">= 3.0.0"
  }

#  backend "s3" {
#    region = "ap-southeast-1"
#    profile = "default"
#    key = "terraformstatefile"
#    bucket = "terraformstatemybucket008888"
#
#  }
}
