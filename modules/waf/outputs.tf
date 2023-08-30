output "arn" {
  description = "The arn for WAF"
  value       = aws_wafv2_web_acl.web_acl.arn
}

output "name" {
  description = "The name for WAF ACL"
  value       = aws_wafv2_web_acl.web_acl.name
}
