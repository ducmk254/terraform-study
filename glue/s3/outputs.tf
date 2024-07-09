output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

# output "landing_zone_customers_key" {
#   description = "The key for the landing zone customers folder"
#   value       = aws_s3_bucket_object.landing_zone_customers[*].key
# }
