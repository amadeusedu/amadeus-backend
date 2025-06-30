resource "aws_wafv2_web_acl" "api_acl" {
  name        = "amadeus-api-acl"
  description = "OWASP Top-10 protections"
  scope       = "REGIONAL"

  default_action { allow {} }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AmadeusApiAcl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action { none {} }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSCommonRules"
      sampled_requests_enabled   = true
    }
  }

  tags = local.tags
}

resource "aws_wafv2_web_acl_association" "api_acl_assoc" {
  resource_arn = aws_apigatewayv2_api.dev_api.execution_arn
  web_acl_arn  = aws_wafv2_web_acl.api_acl.arn
}
