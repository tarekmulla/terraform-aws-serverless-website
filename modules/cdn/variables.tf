variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN for the domain certificate in ACM"
}

variable "domain" {
  type        = string
  description = "The website domain"
}

variable "waf_arn" {
  type        = string
  description = "The ARN for the WAF"
}

variable "logging_bucket" {
  type        = string
  description = "The bucket domain name to store cloudfront logs"
}

variable "origin" {
  type        = string
  description = "The content origin for CDN"
}

variable "api_id" {
  type        = string
  description = "The api Invoke ID"
}

variable "region" {
  type        = string
  description = "The aws region"
}
