variable "security_scraper_api_gateway_url" {
  description = "URL of the security scraper API gateway"
  type        = string
}

variable "cognito_authority" {
  description = "Cognito authority URL"
  type        = string
}

variable "cognito_client_id" {
  description = "Cognito client ID"
  type        = string
}

variable "cognito_redirect_uri" {
  description = "Cognito redirect URI"
  type        = string
}

variable "frontend_lambda_name" {
  description = "Name of the frontend lambda function"
  type        = string
  default     = "security-scraper-frontend"
}

variable "frontend_lambda_url" {
  description = "The URL of the frontend Lambda function"
  type        = string
}
