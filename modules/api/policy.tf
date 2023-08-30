resource "aws_iam_role" "api_role" {
  name = "${var.app}-${terraform.workspace}-api-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authorizer_invocation_policy" {
  name = "${var.app}_${terraform.workspace}-authorizer-invocation"
  role = aws_iam_role.api_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${module.api_authorizer.lambda_authorizer_arn}"
    }
  ]
}
EOF
}
