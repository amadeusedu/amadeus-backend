variable "log_group_name" {
  description = "CloudWatch Log Group name for API access logs"
  type        = string
  default     = "/amadeus/api/access"
}

variable "elk_delivery_stream_name" {
  description = "Kinesis Firehose stream name that ships logs to ELK/Grafana Loki"
  type        = string
  default     = "api-log-stream"
}

variable "alarm_sns_topic_arn" {
  description = "SNS Topic ARN for alert notifications"
  type        = string
}


variable "enable_firehose" {
  description = "Set to true to forward logs to OpenSearch/Grafana via Firehose"
  type        = bool
  default     = false
}

variable "logs_bucket_name" {
  description = "S3 bucket for Firehose backup (required if enable_firehose)"
  type        = string
  default     = ""
}
