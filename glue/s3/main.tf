provider "aws" {
  region = local.region # region lấy giá trị từ file locals.tf
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws" # Sử dụng module S3 có sẵn
  version = "~> 3.0"

  bucket = "ducmk254-glue-${local.environment}"

  tags = {
    Environment = local.environment
    Project     = local.project
  }
}

# resource "aws_s3_bucket_object" "landing_zone_customers" {
#   bucket = module.s3_bucket.s3_bucket_id
#   key    = "landing_zone/customers/year=2024/month=7/day=9/"
# }
