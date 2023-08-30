data "aws_caller_identity" "current" {}

module "website_files" {
  source   = "hashicorp/dir/template"
  base_dir = "../webapp/build"
}

resource "aws_s3_object" "static_files" {
  for_each = module.website_files.files

  bucket       = var.app_bucket_id
  key          = "website/${each.key}"
  content_type = each.value.content_type

  # The template_files module guarantees that only one of these two attributes
  # will be set for each file, depending on whether it is an in-memory template
  # rendering result or a static file on disk.
  source  = each.value.source_path
  content = each.value.content

  # Unless the bucket has encryption enabled, the ETag of each object is an
  # MD5 hash of that object.
  source_hash = each.value.digests.md5

  depends_on = [
    aws_s3_bucket_server_side_encryption_configuration.s3_encryption
  ]
}
