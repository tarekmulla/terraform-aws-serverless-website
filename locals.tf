# create a list of tag to be added to all resources (identify resources related to this question)
locals {
  tags = merge({
    Name        = "${var.app}-${terraform.workspace}"
    Application = var.app
    Repository  = "https://github.com/tarekmulla/terraform-aws-serverless-website"
    Environment = terraform.workspace
    Type        = "Serverless Website"
    Created_By  = "Terraform"
    Description = "Terraform module to create single-page serverless website in AWS"
  }, var.tags)
}
