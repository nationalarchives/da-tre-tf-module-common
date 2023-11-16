resource "aws_kms_key" "da_eventbus" {
  description             = "This key is used to encrypt ${var.env}-da-eventbus SNS Topic messages"
  enable_key_rotation     = true
  multi_region            = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "da_eventbus" {
  name          = "alias/kms/${var.env}/da-eventbus"
  target_key_id = aws_kms_key.da_eventbus.key_id
}

resource "aws_kms_key_policy" "da_eventbus_policy" {
  key_id    = aws_kms_key.da_eventbus.key_id
  policy = data.aws_iam_policy_document.da_eventbus_kms_key.json
}

module "common_data_bucket_kms_key" {
  source = "github.com/nationalarchives/da-terraform-modules//kms?ref=feature-DTE-915-add-permissions-boundary-argument"
  key_name = "${var.env}-${var.prefix}-common-data-kms"
  tags = {}
  default_policy_variables = {
    user_roles = var.tre_data_bucket_write_access
    ci_roles = [var.kms_key_administration_role]
    service_names = ["cloudwatch"]
  }
  permissions_boundary = var.tre_permission_boundary_arn
}
