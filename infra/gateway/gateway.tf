# infra/gateway/gateway.tf
# API Gateway HTTP API, integration, routes, stage, and logs

resource "aws_apigatewayv2_api" "dev_api" {
  name          = "amadeus-api"
  protocol_type = "HTTP"
  tags          = local.tags
}
  api_id                 = aws_apigatewayv2_api.dev_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.status_fn.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

  api_id    = aws_apigatewayv2_api.dev_api.id
  route_key = "GET /status"
  target    = "integrations/${aws_apigatewayv2_integration.status_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/http-api/${aws_apigatewayv2_api.dev_api.id}"
  retention_in_days = 7
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.rate_limit_burst
    throttling_rate_limit  = var.rate_limit_rate
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      time      = "$context.requestTime"
      requestId = "$context.requestId"
      routeKey  = "$context.routeKey"
      status    = "$context.status"
      latency   = "$context.responseLatency"
    })
  }

  tags = local.tags
}
