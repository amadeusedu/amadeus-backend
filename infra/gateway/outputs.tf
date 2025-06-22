output "api_base_url" {
  description = "Default AWS URL for the dev API"
  value       = aws_apigatewayv2_api.dev_api.api_endpoint
}
