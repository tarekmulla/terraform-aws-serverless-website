locals {
  s3_origin_id        = "S3WebappOrigin"
  s3_images_origin_id = "S3ImagesOrigin"
  api_origin_id       = "APIOrigin"
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.app}-${terraform.workspace}-s3-bucket-access"
  description                       = "OAC to access s3 bucket website files"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.origin
    origin_id                = local.s3_images_origin_id
    origin_path              = "/images"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  origin {
    domain_name              = var.origin
    origin_id                = local.s3_origin_id
    origin_path              = "/website"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  origin {
    domain_name = replace(var.api_id, "/^https?://([^/]*).*/", "$1")
    origin_id   = local.api_origin_id
    origin_path = "/${terraform.workspace}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  web_acl_id          = var.waf_arn
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cache for ${var.app} website in ${terraform.workspace} environment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = var.logging_bucket
    prefix          = "logs/cloudfront"
  }

  # If you have domain configured use it here
  aliases = [var.domain, "www.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_images_origin_id

    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.remove_path.arn
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "OPTIONS", "HEAD"]
    target_origin_id = local.api_origin_id
    compress         = false

    origin_request_policy_id = aws_cloudfront_origin_request_policy.api_origin_request_policy.id
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.remove_path.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  price_class = "PriceClass_200"

  tags = var.tags

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_function" "remove_path" {
  name    = "${var.app}-${terraform.workspace}-remove-path"
  runtime = "cloudfront-js-1.0"
  comment = "cloudfront function to remove path from url (e.g. 'api/')"
  publish = true
  code    = file("${path.module}/remove_path.js")
}

resource "aws_cloudfront_origin_request_policy" "api_origin_request_policy" {
  name    = "${var.app}-${terraform.workspace}-origin-policy"
  comment = "Allowed custom headers in the api request"
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["x-api-key", "user-agent"]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}
