
output "active_stage_color" {
  description = "Colour currently serving production traffic"
  value       = aws_apigatewayv2_stage.bg_stage.name
}
