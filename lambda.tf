resource "aws_lambda_function" "common_tre_slack_alerts" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}da-${var.prefix}-slack-notifications:${var.common_image_versions.tre_slack_alerts}"
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

resource "aws_lambda_function" "success_destination" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}da-tre-fn-success-destination:${var.success_destination_image_versions.success_destination}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-success-destination"
  role          = aws_iam_role.success_destination_lambda.arn
  memory_size   = 1024
  timeout       = 30
  environment {
    variables = {
      "DA_EVENTBUS_TOPIC_ARN" = aws_sns_topic.da_eventbus.arn
    }
  }
  tracing_config {
    mode = "Active"
  }

  tags = {
    "ApplicationType" = "Scala"
  }
}

resource "aws_lambda_function" "failure_destination" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}da-tre-fn-failure-destination:${var.failure_destination_image_versions.failure_destination}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-failure-destination"
  role          = aws_iam_role.failure_destination_lambda.arn
  memory_size   = 1024
  timeout       = 30
  environment {
    variables = {
      "DA_EVENTBUS_TOPIC_ARN" = aws_sns_topic.da_eventbus.arn
    }
  }
  tracing_config {
    mode = "Active"
  }

  tags = {
    "ApplicationType" = "Scala"
  }
}
