# Route53 will be manually created in AWS console
data "aws_route53_zone" "domain_zone" {
  name = var.domain
}
