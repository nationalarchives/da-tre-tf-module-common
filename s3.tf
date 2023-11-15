resource "aws_s3_bucket" "common_tre_data" {
  bucket = "${var.env}-${var.prefix}-common-data"
}

resource "aws_s3_bucket_policy" "common_tre_data" {
  bucket = aws_s3_bucket.common_tre_data.bucket
  policy = data.aws_iam_policy_document.common_tre_data_bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "common_tre_data" {
  bucket = aws_s3_bucket.common_tre_data.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.common_data_bucket_kms_key.kms_key_alias
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "common_tre_data" {
  bucket = aws_s3_bucket.common_tre_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "common_tre_data" {
  bucket                  = aws_s3_bucket.common_tre_data.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
