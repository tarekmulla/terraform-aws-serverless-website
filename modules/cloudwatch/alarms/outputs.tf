output "lambda_error_alarm_arn" {
  description = "The ARN of the lambda error alarm."
  value       = module.all_lambdas_errors_alarm.cloudwatch_metric_alarm_arn
}

output "lambda_error_alarm_id" {
  description = "The ID of the lambda error alarm."
  value       = module.all_lambdas_errors_alarm.cloudwatch_metric_alarm_id
}
