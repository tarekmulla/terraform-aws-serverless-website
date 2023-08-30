provider "aws" {
  region = "us-east-1"
}

module "sns" {
  source       = "./modules/sns"
  app              = var.app
  alert_emails = var.alert_emails
  tags         = local.tags
}

module "cloudfront_waf" {
  source = "./modules/waf"
  app    = var.app
  tags   = local.tags
}

module "acm_certificate" {
  source      = "./modules/certificate"
  domain_name = var.domain
  SAN_domains = ["*.${var.domain}"]
  zone_id     = data.aws_route53_zone.domain_zone.zone_id
  tags        = local.tags
}

module "s3_bucket" {
  source = "./modules/bucket"
  app    = var.app
  domain = var.domain
  tags   = local.tags
}

module "lambda_layers" {
  source      = "./modules/lambda_layers"
  app         = var.app
  region      = var.region
  bucket_name = module.s3_bucket.id
  tags        = local.tags
}

module "cdn" {
  source              = "./modules/cdn"
  app                 = var.app
  region              = var.region
  domain              = var.domain
  acm_certificate_arn = module.acm_certificate.arn
  waf_arn             = module.cloudfront_waf.arn
  logging_bucket      = module.s3_bucket.bucket_domain_name
  origin              = module.s3_bucket.bucket_regional_domain_name
  api_id              = module.api.endpoint
  tags                = local.tags

  depends_on = [
    module.cloudfront_waf
  ]
}

module "website" {
  source              = "./modules/website"
  app                 = var.app
  app_bucket_arn      = module.s3_bucket.arn
  app_bucket_id       = module.s3_bucket.id
  cloudfront_dist_arn = module.cdn.cloudfront_dist_arn
  tags                = local.tags
  depends_on = [
    module.s3_bucket,
    module.cdn
  ]
}

module "dns" {
  source                    = "./modules/dns"
  route53_domain            = var.domain
  zone_id                   = data.aws_route53_zone.domain_zone.id
  cloudfront_domain         = module.cdn.cloudfront_domain
  cloudfront_hosted_zone_id = module.cdn.cloudfront_hosted_zone_id
  tags                      = local.tags
}

module "api" {
  source            = "./modules/api"
  app               = var.app
  website_domain    = var.domain
  certificate_arn   = module.acm_certificate.arn
  bucket_name       = module.s3_bucket.id
  lambda_layer_arns = module.lambda_layers.layer_arns
  tags              = local.tags

  depends_on = [
    module.acm_certificate
  ]
}

module "alarms" {
  source              = "./modules/cloudwatch/alarms"
  app                 = var.app
  email_sns_topic_arn = terraform.workspace == "prod" ? module.sns.email_sns_topic_arn : ""
  tags                = local.tags
}

module "dashboard" {
  source                 = "./modules/cloudwatch/dashboard"
  app                    = var.app
  api_name               = module.api.name
  bucket_name            = module.s3_bucket.id
  cloudfront_dist_id     = module.cdn.cloudfront_dist_id
  waf_name               = module.cloudfront_waf.name
  lambda_contact_name    = module.api.lambda_contact_name
  lambda_authorizer_name = module.api.lambda_authorizer_name
  certificate_arn        = module.acm_certificate.arn
  tags                   = local.tags
}
