# Create deployment if any change detected in methods or API
resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on = [
    aws_api_gateway_account.api_cloudwatch_role
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(concat([
      aws_api_gateway_resource.contact.id,
      module.contact.method_id,
      module.contact.integration_id,
      module.api_authorizer.id,
      module.api_authorizer.lambda_authorizer_arn]
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = terraform.workspace
}
