variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.20.2.0/24"
}

variable "az" {
  description = "Availability Zone for subnets"
  type        = string
  default     = "ap-southeast-2a"
}
