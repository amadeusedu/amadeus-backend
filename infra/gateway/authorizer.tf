# JWT Authorizer attached to the existing HTTP API
resource "aws_apigatewayv2_authorizer" "jwt_auth" {
  api_id          = aws_apigatewayv2_api.dev_api.id
  name            = "jwt-authorizer"
  authorizer_type = "JWT"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = var.auth_issuer_url
    audience = var.auth_audience
  }

  tags = local.tags
}
