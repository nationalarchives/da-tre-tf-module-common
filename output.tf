output "common_tre_slack_alerts_topic_arn" {
  value       = aws_sns_topic.common_tre_slack_alerts.arn
  description = "ARN of the Common TRE Slack Alerts"
}

output "common_tre_data_bucket" {
  value       = aws_s3_bucket.common_tre_data.bucket
  description = "Common TRE Data Bucket"
}

output "common_tre_internal_topic_arn" {
  value       = aws_sns_topic.tre_internal.arn
  description = "Common TRE internal topic arn"
}

output "common_tre_out_topic_arn" {
  value       = aws_sns_topic.tre_out.arn
  description = "Common TRE out topic arn"
}

output "common_tre_out_topic_kms_arn" {
  value       = aws_kms_key.tre_out_sns.arn
  description = "Common TRE out topic kms arn"
}

output "tre_dlq_alerts_lambda_function_name" {
  value       = aws_lambda_function.tre_dlq_slack_alerts.function_name
  description = "TRE DLQ Alerts Lambda Function Name"
}

output "success_handler_lambda_arn" {
  value       = aws_lambda_function.tre_success_handler.arn
  description = "Success handler Lambda ARN"
}

output "failure_handler_lambda_arn" {
  value       = aws_lambda_function.tre_failure_handler.arn
  description = "Failure handler Lambda ARN"
}
