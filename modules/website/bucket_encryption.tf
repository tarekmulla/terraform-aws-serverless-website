# enable SSE-KMS encryption in the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = var.app_bucket_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
