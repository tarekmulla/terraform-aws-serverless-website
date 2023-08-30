resource "aws_api_gateway_method" "contact" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = "POST"
  authorization = "CUSTOM"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "contact_lambda_integration" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_method.contact.resource_id
  http_method = aws_api_gateway_method.contact.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.contact_lambda.lambda_function_invoke_arn
}
