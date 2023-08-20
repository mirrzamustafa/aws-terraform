resource "aws_s3_bucket" "app_bucket" {
  bucket        = format("%s-%s", var.app_bucket_name, terraform.workspace)
  force_destroy = true

  lifecycle {
    ignore_changes = [server_side_encryption_configuration]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_state_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "app_state_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}