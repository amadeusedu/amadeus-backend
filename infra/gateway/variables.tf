variable "auth_issuer_url" {
  description = "URL of the future Auth service that will issue JWTs"
  type        = string
  default     = "https://auth.dev.amadeus-academics.com"
}

variable "auth_audience" {
  description = "Audience claim expected in incoming JWTs (array)"
  type        = list(string)
  default     = ["amadeus-academics-api"]
}
