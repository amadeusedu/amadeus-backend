# P95 Latency metric alarm (>1000ms)
resource "aws_cloudwatch_metric_alarm" "latency_p95" {
  alarm_name          = "AmadeusAPI-P95-Latency"
  alarm_description   = "API p95 latency > 1s"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 1000
  treat_missing_data  = "notBreaching"
  metric_query {
    id          = "p95lat"
    expression  = "P95"
  }
  metric_query {
    id = "m1"
    metric {
      metric_name = "Latency"
      namespace   = "AWS/ApiGateway"
      period      = 60
      stat        = "p95"
      dimensions = {
        ApiId = aws_apigatewayv2_api.dev_api.id
      }
    }
  }
  ok_actions   = [var.alarm_sns_topic_arn]
  alarm_actions = [var.alarm_sns_topic_arn]
}

# 5XX Error rate alarm (>1 error in 60s)
resource "aws_cloudwatch_metric_alarm" "errors_5xx" {
  alarm_name          = "AmadeusAPI-5xx-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  namespace           = "AWS/ApiGateway"
  metric_name         = "5XXError"
  statistic           = "Sum"
  period              = 60
  dimensions = {
    ApiId = aws_apigatewayv2_api.dev_api.id
  }
  ok_actions     = [var.alarm_sns_topic_arn]
  alarm_actions  = [var.alarm_sns_topic_arn]
  treat_missing_data = "notBreaching"
}
