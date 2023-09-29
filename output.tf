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

output "common_da_eventbus_topic_arn" {
  value       = aws_sns_topic.da_eventbus.arn
  description = "Common DA eventbus topic arn"
}

output "common_da_eventbus_topic_kms_arn" {
  value       = aws_kms_key.da_eventbus.arn
  description = "Common DA eventbus topic kms arn"
}

output "tre_dlq_alerts_lambda_function_name" {
  value       = aws_lambda_function.tre_dlq_slack_alerts.function_name
  description = "TRE DLQ Alerts Lambda Function Name"
}

output "success_destination_lambda_arn" {
  value       = aws_lambda_function.success_destination.arn
  description = "Success destination Lambda ARN"
}

output "failure_destination_lambda_arn" {
  value       = aws_lambda_function.failure_destination.arn
  description = "Failure destination Lambda ARN"
}
