locals {
  function_name = "authorizer"
  zip_path      = "${path.root}/../.tmp/${local.function_name}.zip"
}

data "archive_file" "lambda_source_package" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = local.zip_path
}

resource "aws_s3_object" "lambda_code_zip" {
  bucket = var.bucket_name
  key    = "lambda_zip/function/${local.function_name}"
  source = local.zip_path
  etag   = data.archive_file.lambda_source_package.output_md5
}

module "authorizer_lambda" {
  depends_on = [aws_s3_object.lambda_code_zip]
  source     = "terraform-aws-modules/lambda/aws"
  version    = "6.5.0"

  function_name  = "${var.app}-${terraform.workspace}-authorizer"
  description    = "lambda function to authorize the app invocation"
  handler        = "index.handler"
  runtime        = "nodejs16.x"
  create_package = false
  s3_existing_package = {
    bucket     = var.bucket_name
    key        = aws_s3_object.lambda_code_zip.id
    version_id = aws_s3_object.lambda_code_zip.version_id
  }

  attach_policy_statements = true
  policy_statements = {
    ses = {
      effect    = "Allow",
      actions   = ["ssm:GetParameter"],
      resources = ["*"]
    }
  }

  cloudwatch_logs_retention_in_days = 14

  environment_variables = {
    APP = var.app
    ENV = terraform.workspace
  }

  tags = var.tags
}
