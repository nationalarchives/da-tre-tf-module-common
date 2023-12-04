resource "aws_sqs_queue" "process_monitoring_queue" {
  name = "${var.env}-${var.prefix}-process-monitoring-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.process_monitoring_queue_deadletter.arn}"
    maxReceiveCount     = 5
  })
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue_policy" "process_monitoring_queue" {
  queue_url = aws_sqs_queue.process_monitoring_queue.id
  policy    = data.aws_iam_policy_document.tre_court_document_parse_in_queue.json
}

resource "aws_sqs_queue" "process_monitoring_queue_deadletter" {
  name                    = "${var.env}-${var.prefix}-process-monitoring-queue-deadletter"
  sqs_managed_sse_enabled = true
}

