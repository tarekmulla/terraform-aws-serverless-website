resource "random_password" "api_auth_token" {
  length  = 50
  special = false
}

resource "aws_ssm_parameter" "api_auth_token_ssm" {
  name  = "/${var.app}/${terraform.workspace}/api_auth_token"
  type  = "SecureString"
  value = random_password.api_auth_token.result
}
