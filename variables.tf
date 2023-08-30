variable "app" {
  type        = string
  description = "The application name"
  default     = "simple-website"
}

variable "region" {
  type        = string
  description = "The aws region where the resources will be provisioned"
  default     = "us-east-1"
}

# A map of the extra tags to apply to aws resources.
# there is already list of tags will be added by default, please
# check locals "tags"
variable "tags" {
  type        = map(string)
  description = "AWS Tags to add to all resources created (where possible)"
  default     = {}
}

variable "domain" {
  type        = string
  description = "The application domain"
}

variable "alert_emails" {
  type        = list(string)
  description = "The email addresses list"
  default     = ["alert@example.com"]
}
