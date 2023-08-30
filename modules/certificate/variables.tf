variable "tags" {
  description = "AWS Tags to add to all resources created (where possible)"
  type        = map(string)
}

variable "domain_name" {
  type        = string
  description = "The application domain name"
}

variable "SAN_domains" {
  type        = list(string)
  description = "The subject alternative domains to include in the certificate (API domain, etc..)"
}

variable "zone_id" {
  type        = string
  description = "The Hosted Zone ID for parent domain"
}
