# S3 bucket to store the website files
resource "aws_s3_bucket" "website" {
  bucket        = "${var.app}-${terraform.workspace}"
  force_destroy = true
  tags          = var.tags
}

# Enable objects versioning
resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "website_ownership_controls" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block S3 public access
resource "aws_s3_bucket_acl" "website_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.website_ownership_controls]

  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "website_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["https://${var.domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
