resource "aws_apigatewayv2_usage_plan" "default" {
  name = "default-usage-plan"

  api_stages {
    api_id = aws_apigatewayv2_api.dev_api.id
    stage  = var.deployment_color
  }

  throttle_settings {
    burst_limit = var.rate_limit_burst
    rate_limit  = var.rate_limit_rate
  }

  tags = local.tags
}
