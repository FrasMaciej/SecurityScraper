variable "frontend_lambda_name" {
  description = "Name of the Lambda function for fetching data from shodan API"
  type        = string
}

variable "security_scraper_api_gateway_url" {
  type = string
}