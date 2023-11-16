# SNS Policies

data "aws_iam_policy_document" "common_tre_slack_alerts_sns_topic_policy" {
  statement {
    actions = ["sns:Publish"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.tre_slack_alerts_publishers
    }
    resources = [aws_sns_topic.common_tre_slack_alerts.arn]
  }
}

# Lambda Policies

resource "aws_iam_role" "common_tre_slack_alerts_lambda_role" {
  name                 = "${var.env}-${var.prefix}-common-slack-alerts-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "common_tre_slack_alerts_policy" {
  role       = aws_iam_role.common_tre_slack_alerts_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

resource "aws_iam_role" "tre_dlq_alerts_lambda" {
  name                 = "${var.env}-${var.prefix}-dlq-alerts-lambda"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "tre_dlq_alerts_lambda" {
  role       = aws_iam_role.tre_dlq_alerts_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role" "success_destination_lambda" {
  name                 = "${var.env}-${var.prefix}-success-destination-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "success_destination_lambda_logs" {
  role       = aws_iam_role.success_destination_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

resource "aws_iam_role" "failure_destination_lambda" {
  name                 = "${var.env}-${var.prefix}-failure-destination-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

#resource "aws_iam_role" "no_hope_lambda" {
#  name                 = "${var.env}-${var.prefix}-no-hope-role"
#  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
#  permissions_boundary = var.tre_permission_boundary_arn
#}

resource "aws_iam_role" "dri_prod_tre_editorial_judgment_out_copier" {
  count              = var.env == "pte-ih" ? 1 : 0
  name               = "${var.env}-${var.prefix}-editorial-judgment-out-copier"
  assume_role_policy = data.aws_iam_policy_document.editorial_judgment_out_copier_access_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

#resource "aws_iam_role_policy_attachment" "editorial_judgment_out_copier_buckets" {
#  count      = var.env == "pte-ih" ? 1 : 0
#  role       = aws_iam_role.dri_prod_tre_editorial_judgment_out_copier.name
#  policy_arn = aws_iam_policy.editorial_judgment_out_copier_buckets_access_policy.arn
#}
#
#resource "aws_iam_policy" "editorial_judgment_out_copier_buckets_access_policy" {
#  count       = var.env == "pte-ih" ? 1 : 0
#  name        = "${var.env}-${var.prefix}-editorial_judgment_out"
#  description = "The s3 policy to allow lambda to read from the tdr transfer bucket"
#  policy      = data.aws_iam_policy_document.editorial_judgment_out_copier_access_policy.json
#}

data "aws_iam_policy_document" "editorial_judgment_out_copier_access_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::prod-tre-editorial-judgment-out"
    ]
  },
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::prod-tre-editorial-judgment-out/*"

    ]
  }
#  statement {
#    actions = [
#      "s3:PutObject",
#      "s3:ListBucket",
#    ]
#    effect = "Allow"
#    resources = [
#      "arn:aws:s3:::prod-ingest-parsed-court-document-test-input/*",
#      "arn:aws:s3:::prod-ingest-parsed-court-document-test-input",
#      "arn:aws:s3:::intg-ingest-parsed-court-document-test-input/*",
#      "arn:aws:s3:::intg-ingest-parsed-court-document-test-input",
#      "arn:aws:s3:::staging-ingest-parsed-court-document-test-input/*",
#      "arn:aws:s3:::staging-ingest-parsed-court-document-test-input"
#    ]
#  }
#  statement {
#    effect = "Allow"
#    actions = [
#      "kms:GenerateDataKey",
#      "kms:Decrypt"
#    ]
#    resources = [
#      "arn:aws:kms:eu-west-2:059334750967:key/37b61f81-99ad-43f0-b00b-b9bbb000cdaf",
#      "arn:aws:kms:eu-west-2:897688892737:key/9b0dd233-c792-4ba6-b260-844d73c9f65c"
#    ]
#  }
#  statement {
#    effect = "Allow"
#    actions = [
#      "sts:AssumeRole"
#    ]
#    principals {
#      type = "AWS"
#      identifiers = [
#        "arn:aws:iam::059334750967:role/intg-copy-from-tre-bucket-role",
#        "arn:aws:iam::897688892737:role/staging-copy-from-tre-bucket-role"
#      ]
#    }
#  }
}

resource "aws_iam_role_policy_attachment" "failure_destination_lambda_logs" {
  role       = aws_iam_role.failure_destination_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

# S3 Policy

data "aws_iam_policy_document" "common_tre_data_bucket" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    principals {
      type        = "AWS"
      identifiers = var.tre_data_bucket_write_access
    }

    resources = ["${aws_s3_bucket.common_tre_data.arn}/*", aws_s3_bucket.common_tre_data.arn]
  }
}

# KMS Key Policy

data "aws_iam_policy_document" "da_eventbus_topic_policy" {
  dynamic "statement" {
    for_each = concat(
      var.da_eventbus_client_account_ids,
      var.da_eventbus_publishers,
      [
        aws_iam_role.success_destination_lambda.arn,
        aws_iam_role.failure_destination_lambda.arn
      ]
    )
    content {
      sid = "da-event-bus-client-${statement.value}"
      actions = [
        "sns:Publish",
        "sns:Subscribe"
      ]
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
      resources = [aws_sns_topic.da_eventbus.arn]
    }
  }

  statement {
    sid = "account-${var.env}-eventbus-client"
    actions = [
      "sns:Publish",
      "sns:Subscribe"
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }
    resources = [aws_sns_topic.da_eventbus.arn]
  }
}

data "aws_iam_policy_document" "da_eventbus_kms_key" {

  dynamic "statement" {
    for_each = toset(var.da_eventbus_client_account_ids)
    content {
      sid = "da-event-bus-key-policy-${statement.value}"
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*"
      ]
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
      resources = ["*"]
    }
  }

  statement {
    sid     = "account-${var.env}-da-event-bus-key-policy"
    actions = ["kms:*"]
    effect  = "Allow"
    principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${var.account_id}:root",
        aws_iam_role.success_destination_lambda.arn,
        aws_iam_role.failure_destination_lambda.arn
      ], var.da_eventbus_publishers)
    }
    resources = ["*"]
  }
}

