output "cloudfront_domain" {
  value = replace(aws_cloudfront_distribution.s3_distribution.domain_name, "/[.]$/", "")
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "cloudfront_dist_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_dist_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
