variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "route53_domain" {
  type        = string
  description = "The route53 domain name"
}

variable "zone_id" {
  type        = string
  description = "The Hosted Zone ID for parent domain"
}

variable "cloudfront_domain" {
  type        = string
  description = "The cloudfront domain for the website"
}

variable "cloudfront_hosted_zone_id" {
  type        = string
  description = "The cloudfront hosted zone id"
}
