provider "aws" {
  region = "ap-southeast-2"
}

module "website" {
  source             = "../../"
  app                = var.app
  region             = var.region
  tags               = var.tags
  domain             = var.domain
  alert_emails       = var.alert_emails
  images_path        = var.images_path
  website_files_path = var.website_files_path
}
