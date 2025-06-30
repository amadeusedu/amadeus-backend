variable "aws_region" {
  type = string
}
variable "state_bucket" {
  type = string
}
variable "lock_table" {
  type = string
}
variable "route53_zone_id" {
  type = string
}
variable "domain_name" {
  type = string
}
variable "status_lambda_s3_bucket" {
  type = string
}
variable "status_lambda_s3_key" {
  type = string
}
variable "auth_issuer_url" {
  type = string
}
variable "auth_audience" {
  type = list(string)
}
variable "rate_limit_burst" {
  type    = number
  default = 50
}
variable "rate_limit_rate" {
  type    = number
  default = 20
}
variable "environment" {
  type    = string
  default = "staging"
}
variable "deployment_color" {
  type    = string
  default = "blue"
}
variable "lambda_memory_mb" {
  type    = number
  default = 128
}
variable "lambda_reserved_concurrency" {
  type    = number
  default = 5
}
