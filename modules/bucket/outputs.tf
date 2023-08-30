output "hosted_zone_id" {
  description = "The hosted zone id for the s3 bucket"
  value       = aws_s3_bucket.website.hosted_zone_id
}

output "bucket_regional_domain_name" {
  description = "The regional domain name for the S3 bucket"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "arn" {
  description = "The ARN for the s3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "id" {
  description = "The ID for the s3 bucket"
  value       = aws_s3_bucket.website.id
}
