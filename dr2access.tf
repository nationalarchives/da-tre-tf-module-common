resource "aws_iam_role" "dri_prod_tre_editorial_judgment_out_copier" {
  name                 = "${var.env}-${var.prefix}-editorial-judgment-out-copier"
  assume_role_policy   = data.aws_iam_policy_document.editorial_judgment_out_copier_assume_role_policy[0].json
  permissions_boundary = var.tre_permission_boundary_arn
}

data "aws_iam_policy_document" "editorial_judgment_out_copier_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = var.dri_roles_for_copier_assume
    }
  }
}

resource "aws_iam_role_policy_attachment" "editorial_judgment_out_copier_buckets" {
  role       = aws_iam_role.dri_prod_tre_editorial_judgment_out_copier[0].name
  policy_arn = aws_iam_policy.editorial_judgment_out_copier_buckets_access_policy[0].arn
}

resource "aws_iam_policy" "editorial_judgment_out_copier_buckets_access_policy" {
  name        = "${var.env}-${var.prefix}-editorial-judgment-out-copier"
  description = "The policy to allow the editorial_judgment_out_copier role to read and write data"
  policy      = data.aws_iam_policy_document.editorial_judgment_out_copier_access_policy[0].json
}

data "aws_iam_policy_document" "editorial_judgment_out_copier_access_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::prod-tre-editorial-judgment-out/*",
      "arn:aws:s3:::prod-tre-editorial-judgment-out"
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::prod-ingest-parsed-court-document-test-input/*",
      "arn:aws:s3:::prod-ingest-parsed-court-document-test-input",
      "arn:aws:s3:::intg-ingest-parsed-court-document-test-input/*",
      "arn:aws:s3:::intg-ingest-parsed-court-document-test-input",
      "arn:aws:s3:::staging-ingest-parsed-court-document-test-input/*",
      "arn:aws:s3:::staging-ingest-parsed-court-document-test-input"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = var.kms_copier_destination_buckets
  }
}