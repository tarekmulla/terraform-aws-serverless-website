variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "website_domain" {
  type        = string
  description = "The domain name for the website"
}

variable "certificate_arn" {
  type        = string
  description = "The arn for the acm certificate for the app domain"
}

variable "bucket_name" {
  type        = string
  description = "The S3 bucket name"
}

variable "waf_web_acl" {
  type        = string
  description = "The waf web acl"
  default     = ""
}

variable "lambda_layer_arns" {
  type        = list(string)
  description = "The Invoke ARNs of the Lambda layers"
}
