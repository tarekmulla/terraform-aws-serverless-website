variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "api_name" {
  type        = string
  description = "The name of the API gateway"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "cloudfront_dist_id" {
  type        = string
  description = "The cloudfront distribuation ID"
}

variable "waf_name" {
  type        = string
  description = "The Web application firewall ACL name"
}

variable "lambda_contact_name" {
  type        = string
  description = "The lambda function contact name"
}

variable "lambda_authorizer_name" {
  type        = string
  description = "The lambda function authorizer name"
}

variable "certificate_arn" {
  type        = string
  description = "The ACM certificate ARN"
}
