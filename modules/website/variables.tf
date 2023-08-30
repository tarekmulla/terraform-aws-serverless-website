variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "app_bucket_arn" {
  description = "ARN for the app S3 bucket"
  type        = string
}

variable "app_bucket_id" {
  description = "ID for the app S3 bucket"
  type        = string
}

variable "cloudfront_dist_arn" {
  description = "cloudfront_dist_arn"
  type        = string
}
