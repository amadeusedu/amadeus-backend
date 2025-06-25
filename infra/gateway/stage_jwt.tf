# Apply JWT authorizer globally by default
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.rate_limit_burst
    throttling_rate_limit  = var.rate_limit_rate
    authorization_type     = "JWT"
    authorizer_id          = aws_apigatewayv2_authorizer.jwt_auth.id
  }

  tags = local.tags
}
