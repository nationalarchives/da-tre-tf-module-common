variable "env" {
  description = "Name of the environment to deploy"
  type        = string
}

variable "prefix" {
  description = "Transformation Engine prefix"
  type        = string
}

variable "account_id" {
  description = "Account ID where Image for the Lambda function will be"
  type        = string
}

variable "common_version" {
  description = "(Updates if Common TRE Lambda function versions change)"
  type        = string
}
variable "common_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_slack_alerts     = string
    tre_dlq_slack_alerts = string
  })
}
variable "success_destination_image_versions" {
  description = "Latest version of Images for the success destination Lambda Functions"
  type = object({
    success_destination = string
  })
}
variable "failure_destination_image_versions" {
  description = "Latest version of Images for the failure destination Lambda Functions"
  type = object({
    failure_destination = string
  })
}

variable "tre_slack_alerts_publishers" {
  description = "Roles that have permission to publish messages to tre-slack-alerts topic"
  type        = list(string)
}

variable "tre_data_bucket_write_access" {
  description = "Roles that have write access to tre-data-bucket"
  type        = list(string)
}

variable "slack_webhook_url" {
  description = "Webhook URL for tre slack alerts"
  type        = string
}

variable "slack_channel" {
  description = "Channel name for the tre slack alerts"
  type        = string
}

variable "slack_username" {
  description = "Username for tre slack alerts"
  type        = string
}

variable "da_eventbus_publishers" {
  description = "Roles that have permission to publish messages to da-eventbus topic"
  type        = list(string)
}

variable "tre_permission_boundary_arn" {
  description = "ARN of the TRE permission boundary policy"
  type        = string
}

variable "ecr_uri_host" {
  description = "The hostname part of the management account ECR repository; e.g. ACCOUNT.dkr.ecr.REGION.amazonaws.com"
  type        = string
}

variable "ecr_uri_repo_prefix" {
  description = "The prefix for Docker image repository names to use; e.g. foo/ in ACCOUNT.dkr.ecr.REGION.amazonaws.com/foo/tre-bar"
  type        = string
}

variable "da_eventbus_client_account_ids" {
  description = "Accounts that can use the da event bus"
  type        = list(string)
}

variable "da_eventbus_subscriptions" {
  description = "List tre-da-eventbus topic subscriptions"
  type = list(object({
    name                  = string
    endpoint              = string
    protocol              = string
    raw_message_delivery  = bool
    filter_policy         = any
    filter_policy_scope   = string
    subscription_role_arn = string
  }))
}

variable "notifiable_slack_endpoints_on_error" {
  description = "Channel - webhook url key value pairs to post to in case of TRE errors"
  type        = map(string)
}

variable "kms_key_administration_role" {
  description = "Role to administer kms keys"
  type        = string
}

variable "dri_roles_for_copier_assume" {
  description = "Roles allowed to assume v1 bucket copier role"
  type        = list(string)
}

variable "kms_copier_destination_buckets" {
  description = "KMS keys of bucket into which data is copied"
  type        = list(string)
}
