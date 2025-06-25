
resource "aws_apigatewayv2_stage" "bg_stage" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = var.deployment_color
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.rate_limit_burst
    throttling_rate_limit  = var.rate_limit_rate
    authorization_type     = "JWT"
    authorizer_id          = aws_apigatewayv2_authorizer.jwt_auth.id
  }

  tags = merge(local.tags, {
    Env   = var.environment
    Color = var.deployment_color
  })
}

resource "aws_apigatewayv2_api_mapping" "domain_map" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  domain_name = aws_apigatewayv2_domain_name.custom_domain.id
  stage       = aws_apigatewayv2_stage.bg_stage.name
}
