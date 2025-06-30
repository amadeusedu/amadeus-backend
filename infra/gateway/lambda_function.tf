# infra/gateway/lambda_function.tf
# Lambda function for /status

resource "aws_lambda_function" "status_fn" {
  function_name = "amadeus-status"

  s3_bucket = var.status_lambda_s3_bucket
  s3_key    = var.status_lambda_s3_key

  handler = "index.handler"
  runtime = "nodejs20.x"

  memory_size                    = var.lambda_memory_mb
  reserved_concurrent_executions = var.lambda_reserved_concurrency
  timeout                        = 3

  role = aws_iam_role.lambda_exec.arn
  tags = local.tags
}
