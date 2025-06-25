# Example protected route
resource "aws_apigatewayv2_route" "protected" {
  api_id             = aws_apigatewayv2_api.dev_api.id
  route_key          = "GET /protected"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_auth.id
  target             = "integrations/${aws_apigatewayv2_integration.status_integration.id}"
}
