variable "lambda_memory_mb" {
  description = "Memory size (MB) for backend Lambda functions"
  type        = number
  default     = 512
}

variable "lambda_reserved_concurrency" {
  description = "Reserved concurrency for critical Lambdas"
  type        = number
  default     = 100
}


variable "enable_high_rate_limits" {
  description = "Set true during load test to increase throttle limits"
  type        = bool
  default     = false
}

variable "high_rate_limit_burst" {
  type        = number
  default     = 1000
}

variable "high_rate_limit_rate" {
  type        = number
  default     = 600
}
