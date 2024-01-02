resource "aws_s3_bucket" "this" {
 bucket = "${var.application}-${var.region}-${var.environment}-${var.created}-access"
 force_destroy = true
 tags = var.tags
}


resource "aws_s3_bucket_versioning" "s3_terraform_versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aws_s3_encryption" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      #IMPORTANT Must be S3 default encryption. Any other type is not accepted.
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.this.id
 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    id = "${var.application}-${var.environment}-${var.created}-lb-lifecycle"
    expiration {
      days = var.alb_log_lifecycle_to_infrequent_access_days
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "ONEZONE_IA"
    }
  }
}