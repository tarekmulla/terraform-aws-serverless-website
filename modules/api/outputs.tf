output "endpoint" {
  description = "The public API endpoint"
  value       = aws_api_gateway_deployment.api_deploy.invoke_url
}

output "id" {
  description = "The API id"
  value       = aws_api_gateway_rest_api.api.id
}

output "name" {
  description = "The API name"
  value       = aws_api_gateway_rest_api.api.name
}

output "lambda_contact_name" {
  description = "The lambda function contact name"
  value       = module.contact.lambda_name
}

output "lambda_authorizer_name" {
  description = "The lambda function authorizer name"
  value       = module.api_authorizer.lambda_name
}
