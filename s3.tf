# common data bucket
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

# da-sample-data bucket
resource "aws_s3_bucket" "da_sample_data" {
  bucket = "mk-da-sample-data"
}

resource "aws_s3_bucket_policy" "da_sample_data" {
  bucket = aws_s3_bucket.da_sample_data.bucket
  policy = data.aws_iam_policy_document.da_sample_data_data_bucket.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "da_sample_data" {
  bucket = aws_s3_bucket.da_sample_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "da_sample_data" {
  bucket = aws_s3_bucket.da_sample_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "da_sample_data" {
  bucket                  = aws_s3_bucket.da_sample_data.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
