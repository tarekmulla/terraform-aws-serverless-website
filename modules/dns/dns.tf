# Add an IPv4 DNS record pointing to the s3 bucket
resource "aws_route53_record" "ipv4" {
  zone_id = var.zone_id
  name    = var.route53_domain
  type    = "A"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = true
  }
}

# www record for the webapp
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "3600"
  records = [var.route53_domain]
}
