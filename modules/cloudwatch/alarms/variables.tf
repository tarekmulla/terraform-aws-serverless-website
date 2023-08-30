variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "email_sns_topic_arn" {
  type        = string
  description = "The sns topic arn that sends email"
}
