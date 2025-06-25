resource "aws_iam_role" "lambda_exec" {
  name = "amadeus-status-lambda-exec"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Principal: { Service: "lambda.amazonaws.com" },
      Action: "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "status_fn" {
  function_name = "amadeus-status"
  s3_bucket     = var.status_lambda_s3_bucket
  s3_key        = var.status_lambda_s3_key
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  memory_size   = 128
  timeout       = 3
  role          = aws_iam_role.lambda_exec.arn
  tags          = local.tags
}
