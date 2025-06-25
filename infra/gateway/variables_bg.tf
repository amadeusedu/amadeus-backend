
variable "environment" {
  description = "Terraform workspace: staging or production"
  type        = string
}

variable "deployment_color" {
  description = "Blue or green stage to deploy"
  type        = string
  validation {
    condition     = contains(["blue", "green"], var.deployment_color)
    error_message = "deployment_color must be blue or green"
  }
}
