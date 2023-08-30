module "all_lambdas_errors_alarm" {
  source = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"

  alarm_name          = "${var.app}-${terraform.workspace}-all-lambda-errors"
  alarm_description   = "Alarm for Lambda function errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 120
  unit                = "Count"

  namespace          = "AWS/Lambda"
  metric_name        = "Errors"
  statistic          = "Sum"
  treat_missing_data = "notBreaching"

  alarm_actions = [var.email_sns_topic_arn]
}
