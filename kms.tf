resource "aws_kms_key" "da_eventbus" {
  description             = "This key is used to encrypt ${var.env}-da-eventbus SNS Topic messages"
  enable_key_rotation     = true
  multi_region            = true
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.da_eventbus_kms_key.json
}

resource "aws_kms_alias" "da_eventbus" {
  name          = "alias/kms/${var.env}/da-eventbus"
  target_key_id = aws_kms_key.da_eventbus.key_id
}
