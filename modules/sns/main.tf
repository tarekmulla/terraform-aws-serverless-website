resource "aws_sns_topic" "email_topic" {
  name = "${var.app}-${terraform.workspace}-email"
}

resource "aws_sns_topic_subscription" "send_alert_email" {
  for_each  = toset(var.alert_emails)
  topic_arn = aws_sns_topic.email_topic.arn
  protocol  = "email"
  endpoint  = each.value
}
