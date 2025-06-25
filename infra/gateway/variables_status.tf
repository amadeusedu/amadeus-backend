variable "status_lambda_s3_bucket" {
  description = "S3 bucket where status.zip is stored"
  type        = string
}

variable "status_lambda_s3_key" {
  description = "S3 key of the Lambda ZIP"
  type        = string
}

# global throttling defaults (safe for prod)
variable "rate_limit_burst" {
  description = "Burst requests per second"
  type        = number
  default     = 50
}

variable "rate_limit_rate" {
  description = "Sustained requests per second"
  type        = number
  default     = 20
}
