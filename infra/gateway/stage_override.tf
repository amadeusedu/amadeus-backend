# Temporarily raise throttling limits when enable_high_rate_limits=true
resource "aws_apigatewayv2_stage" "bg_stage_override" {
  count       = var.enable_high_rate_limits ? 1 : 0
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = aws_apigatewayv2_stage.bg_stage.name
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.high_rate_limit_burst
    throttling_rate_limit  = var.high_rate_limit_rate
    authorization_type     = "JWT"
    authorizer_id          = aws_apigatewayv2_authorizer.jwt_auth.id
  }

  tags = merge(local.tags, { LoadTest = "true" })
}
