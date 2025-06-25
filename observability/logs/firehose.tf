# Conditional Firehose delivery stream
resource "aws_s3_bucket" "logs_bucket" {
  count = var.enable_firehose ? 1 : 0
  bucket = var.logs_bucket_name
  force_destroy = true
}

resource "aws_iam_role" "firehose_role" {
  count = var.enable_firehose ? 1 : 0
  name  = "amadeus-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Principal: { Service: "firehose.amazonaws.com" },
      Action: "sts:AssumeRole"
    }]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "elk_stream" {
  count       = var.enable_firehose ? 1 : 0
  name        = var.elk_delivery_stream_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role[0].arn
    bucket_arn         = aws_s3_bucket.logs_bucket[0].arn
    buffering_interval = 300
    buffering_size     = 5
  }
}

resource "aws_cloudwatch_log_subscription_filter" "firehose_sub" {
  count           = var.enable_firehose ? 1 : 0
  name            = "api-log-subscription"
  log_group_name  = aws_cloudwatch_log_group.api_access.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.elk_stream[0].arn
}
