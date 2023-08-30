resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                             = "${var.app}-${terraform.workspace}-api-authorizer"
  rest_api_id                      = var.api_id
  authorizer_uri                   = module.authorizer_lambda.lambda_function_invoke_arn
  authorizer_credentials           = var.api_role_arn
  authorizer_result_ttl_in_seconds = 300 // Enable caching
  type                             = "TOKEN"
  identity_source                  = "method.request.header.x-api-key"
}
