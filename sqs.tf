resource "aws_sqs_queue" "monitoring_queue" {
  name = "${var.env}-${var.prefix}-monitoring-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.monitoring_queue_deadletter.arn}"
    maxReceiveCount     = 5
  })
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue_policy" "monitoring_queue" {
  queue_url = aws_sqs_queue.monitoring_queue.id
  policy    = data.aws_iam_policy_document.monitoring_queue.json
}

resource "aws_sqs_queue" "monitoring_queue_deadletter" {
  name                    = "${var.env}-${var.prefix}-monitoring-queue-deadletter"
  sqs_managed_sse_enabled = true
}

