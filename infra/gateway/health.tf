resource "aws_route53_health_check" "api_status" {
  fqdn          = var.domain_name
  resource_path = "/status"
  type          = "HTTPS"
  port          = 443
  failure_threshold = 3
  request_interval = 30
  tags          = local.tags
}
