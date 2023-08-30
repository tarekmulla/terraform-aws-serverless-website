module "website_images" {
  source   = "hashicorp/dir/template"
  base_dir = "../webapp/images"
}

resource "aws_s3_object" "images" {
  for_each = module.website_images.files

  bucket       = var.app_bucket_id
  key          = "images/${each.key}"
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
