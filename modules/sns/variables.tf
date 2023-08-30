variable "app" {
  type        = string
  description = "The application name"
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "alert_emails" {
  type        = list(string)
  description = "The addresses that require to receive email"
}
