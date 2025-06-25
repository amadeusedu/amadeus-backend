resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.rate_limit_burst
    throttling_rate_limit  = var.rate_limit_rate
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_access.arn
    format = jsonencode({
      time        = '$context.requestTime'
      requestId   = '$context.requestId'
      routeKey    = '$context.routeKey'
      status      = '$context.status'
      latency_ms  = '$context.responseLatency'
    })
  }

  tags = local.tags
}
