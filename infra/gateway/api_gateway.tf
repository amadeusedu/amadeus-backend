resource "aws_apigatewayv2_api" "dev_api" {
  name          = "amadeus-api"
  protocol_type = "HTTP"
  tags          = local.tags
}

resource "aws_apigatewayv2_integration" "status_integration" {
  api_id                 = aws_apigatewayv2_api.dev_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.status_fn.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "status_route" {
  api_id    = aws_apigatewayv2_api.dev_api.id
  route_key = "GET /status"
  target    = "integrations/${aws_apigatewayv2_integration.status_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/http-api/${aws_apigatewayv2_api.dev_api.id}"
  retention_in_days = 7
}
