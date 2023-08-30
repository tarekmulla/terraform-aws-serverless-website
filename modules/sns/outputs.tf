output "email_sns_topic_id" {
  description = "The ID of the SNS topic to send email"
  value       = aws_sns_topic.email_topic.id
}

output "email_sns_topic_arn" {
  description = "The ARN of the SNS topic to send email"
  value       = aws_sns_topic.email_topic.arn
}
