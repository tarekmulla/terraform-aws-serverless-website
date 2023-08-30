resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.app}-${terraform.workspace}"
  description = "API for ${var.app} in ${terraform.workspace} environment"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "contact" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "contact"
}

module "api_authorizer" {
  source       = "./authorizer"
  app          = var.app
  bucket_name  = var.bucket_name
  api_id       = aws_api_gateway_rest_api.api.id
  api_exec_arn = aws_api_gateway_rest_api.api.execution_arn
  api_role_arn = aws_iam_role.api_role.arn
  tags         = var.tags
}

# Each method has a separate module block
module "contact" {
  source            = "./contact"
  app               = var.app
  api_id            = aws_api_gateway_rest_api.api.id
  resource_id       = aws_api_gateway_resource.contact.id
  api_exec_arn      = aws_api_gateway_rest_api.api.execution_arn
  bucket_name       = var.bucket_name
  lambda_layer_arns = var.lambda_layer_arns
  website_domain    = var.website_domain
  authorizer_id     = module.api_authorizer.id
  tags              = var.tags
}
