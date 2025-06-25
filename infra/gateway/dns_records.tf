# Reserve dev and stage FQDNs for Amadeus Academics
variable "route53_zone_id" {
  description = "Hosted Zone ID for amadeus-academics.com"
  type        = string
}

resource "aws_route53_record" "api_dev" {
  zone_id = var.route53_zone_id
  name    = "api.dev"
  type    = "CNAME"
  ttl     = 300
  records = ["example.com."]  # replace when custom domain is live
}

resource "aws_route53_record" "api_stage" {
  zone_id = var.route53_zone_id
  name    = "api.stage"
  type    = "CNAME"
  ttl     = 300
  records = ["example.com."]  # replace when custom domain is live
}
