resource "aws_lambda_function" "common_tre_slack_alerts" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}${var.prefix}-slack-alerts:${var.common_image_versions.tre_slack_alerts}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-common-slack-alerts"
  role          = aws_iam_role.common_tre_slack_alerts_lambda_role.arn
  timeout       = 30
  environment {
    variables = {
      "SLACK_WEBHOOK_URL" = var.slack_webhook_url
      "ENV"               = var.env
      "SLACK_CHANNEL"     = var.slack_channel
      "SLACK_USERNAME"    = var.slack_username
    }
  }

  tags = {
    "ApplicationType" = "Python"
  }
}

resource "aws_lambda_permission" "common_tre_slack_alerts_sns_trigger_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.common_tre_slack_alerts.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.common_tre_slack_alerts.arn
}

# TRE dlq alerts

resource "aws_lambda_function" "tre_dlq_slack_alerts" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}${var.prefix}-dlq-slack-alerts:${var.common_image_versions.tre_dlq_slack_alerts}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-dlq-slack-alerts"
  role          = aws_iam_role.tre_dlq_alerts_lambda.arn
  timeout       = 30
  environment {
    variables = {
      "SLACK_WEBHOOK_URL" = var.slack_webhook_url
      "ENV"               = var.env
      "SLACK_CHANNEL"     = var.slack_channel
      "SLACK_USERNAME"    = var.slack_username
    }
  }
  tags = {
    "ApplicationType" = "Python"
  }
}

resource "aws_lambda_function" "tre_success_handler" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}mk-junk-example:1.0.20"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-success-handler"
  role          = aws_iam_role.tre_success_handler_lambda.arn
  memory_size   = 1024
  timeout       = 30
  environment {
    variables = {
      "TRE_INTERNAL_TOPIC_ARN" = aws_sns_topic.tre_internal.arn
    }
  }
  tracing_config {
    mode = "Active"
  }

  tags = {
    "ApplicationType" = "Scala"
  }
}
