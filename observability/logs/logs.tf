# Access Log Group
resource "aws_cloudwatch_log_group" "api_access" {
  name              = var.log_group_name
  retention_in_days = 14
  tags              = local.tags
}

# Update API Gateway stage with JSON access logs
resource "aws_apigatewayv2_stage" "bg_stage" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = aws_apigatewayv2_stage.bg_stage.name  # reuse existing stage name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_access.arn
    format          = "{\"time\":\"$context.requestTime\",\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"method\":\"$context.httpMethod\",\"route\":\"$context.routeKey\",\"status\":$context.status,\"latency_ms\":$context.responseLatency}"
  }

  default_route_settings {
    throttling_burst_limit = var.rate_limit_burst
    throttling_rate_limit  = var.rate_limit_rate
    authorization_type     = "JWT"
    authorizer_id          = aws_apigatewayv2_authorizer.jwt_auth.id
  }

  tags = local.tags
}
