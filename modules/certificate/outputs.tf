output "arn" {
  description = "The arn for the acm certificate for the application domain"
  value       = aws_acm_certificate.app.arn
}
