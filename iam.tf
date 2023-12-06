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

resource "aws_iam_role" "process_monitoring_queue_lambda_role" {
  name                 = "${var.env}-${var.prefix}-process-monitoring-queue-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

data "aws_iam_policy_document" "process_monitoring_queue_policy" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.monitoring_queue.arn
    ]
  }
}

resource "aws_iam_policy" "process_monitoring_queue_policy" {
  name   = "${var.env}-${var.prefix}-process-monitoring-queue-policy"
  policy = data.aws_iam_policy_document.process_monitoring_queue_policy.json
}

resource "aws_iam_role_policy_attachment" "process_monitoring_queue_sqs" {
  role       = aws_iam_role.process_monitoring_queue_lambda_role.name
  policy_arn = aws_iam_policy.process_monitoring_queue_policy.arn
}

resource "aws_iam_role_policy_attachment" "process_monitoring_queue_logs" {
  role       = aws_iam_role.process_monitoring_queue_lambda_role.name
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

data "aws_iam_policy_document" "monitoring_queue" {
  statement {
    actions = ["sqs:SendMessage"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com"
      ]
    }
    resources = [
      aws_sqs_queue.monitoring_queue.arn
    ]
  }
}
 