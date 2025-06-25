resource "aws_apigatewayv2_integration" "status_integration" {
  api_id                 = aws_apigatewayv2_api.dev_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.status_fn.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "status_route" {
  api_id             = aws_apigatewayv2_api.dev_api.id
  route_key          = "GET /status"
  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.status_integration.id}"
}

# Lambda permission so API Gateway can invoke
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowInvokeFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.status_fn.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dev_api.execution_arn}/*/*"
}
