variable "pool_name" {
  description = "frontend_user_pool"
  type        = string
}

variable "cognito_domain_prefix" {
  description = "Prefix domeny Cognito"
  type        = string
}

variable "callback_url" {
  type        = string
  description = "URL przekierowania po zalogowaniu"
}

variable "logout_url" {
  type        = string
  description = "URL przekierowania po wylogowaniu"
}

variable "aws_region" {
  type        = string
  description = "Region AWS"
}