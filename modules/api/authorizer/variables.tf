variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "bucket_name" {
  type        = string
  description = "The S3 bucket name"
}

variable "api_exec_arn" {
  type        = string
  description = "The arn for API execution"
}

variable "api_role_arn" {
  type        = string
  description = "The arn for API role"
}

variable "api_id" {
  type        = string
  description = "The API Id"
}
