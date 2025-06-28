###############################################################################
# infra/gateway/terraform.tfvars
# Unified variables for Amadeus Academics Week‑1 stack
###############################################################################

# ----- Day 1: Route 53 Hosted Zone -----
route53_zone_id           = "<YOUR_ROUTE53_ZONE_ID>"          # e.g. Z1ABCDEF123456

# ----- Day 2: /status Lambda artefact -----
status_lambda_s3_bucket   = "<YOUR_LAMBDA_BUCKET_NAME>"
status_lambda_s3_key      = "status.zip"

rate_limit_burst          = 50
rate_limit_rate           = 20

# ----- Day 3: JWT Authorizer -----
auth_issuer_url           = "https://auth.dev.amadeus-academics.com"
auth_audience             = ["amadeus-academics-api"]

# ----- Day 4: Blue / Green (CI overrides) -----
environment               = "staging"    # staging | production
deployment_color          = "blue"       # blue | green

# ----- Day 5: Logs & Alerts (optional) -----
# alarm_sns_topic_arn     = "<SNS_TOPIC_ARN>"
# enable_firehose         = true
# logs_bucket_name        = "<LOGS_BUCKET_NAME>"

# ----- Day 6: Load Test & Lambda tuning (optional) -----
enable_high_rate_limits   = false
high_rate_limit_burst     = 1000
high_rate_limit_rate      = 600
# lambda_memory_mb        = 1024
# lambda_reserved_concurrency = 200
