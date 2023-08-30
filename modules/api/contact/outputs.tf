output "method_id" {
  value = aws_api_gateway_method.contact.id
}

output "integration_id" {
  value = aws_api_gateway_integration.contact_lambda_integration.id
}

output "lambda_name" {
  description = "The lambda function name"
  value       = module.contact_lambda.lambda_function_name
}
