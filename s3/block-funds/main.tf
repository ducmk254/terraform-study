locals {
  bucket_name = "udnt-dev-block-funds"
  region      = "ap-southeast-1"
  account_id  = "365554857056"
}

resource "aws_iam_role" "this" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }

    actions = [
      "s3:ListBucket", #s3:ListBucket
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }
}


# resource "aws_kms_key" "objects" {
#   description             = "KMS key is used to encrypt bucket objects"
#   deletion_window_in_days = 7
# }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
  tags = module.eg_s3_label.tags
}


module "eg_s3_label" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace = "udnt"
  stage     = "dev"
  name      = "block-funds"
  delimiter = "-"

  tags = {
    DeployBy  = "chuankv-hoanglb"
    OwnerBy   = "ManhNh2"
    ManagedBy = "Terraform"
  }
}

