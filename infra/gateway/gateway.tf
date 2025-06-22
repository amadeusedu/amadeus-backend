resource "aws_apigatewayv2_api" "dev_api" {
  name          = "AmadeusDevAPI"
  protocol_type = "HTTP"
  tags          = local.tags
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.dev_api.id
  name        = "$default"
  auto_deploy = true
  tags        = local.tags
}
