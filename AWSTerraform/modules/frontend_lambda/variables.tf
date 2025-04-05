variable "frontend_lambda_name" {
  description = "Name of the Lambda function for fetching data from shodan API"
  type        = string
}

variable "shodan_collector_lambda_url" {
  type = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function for fetching data from Shodan API"
  type        = map(string)
  default     = {
    VITE_SHODAN_LAMBDA_COLLECTOR_URL = var.shodan_collector_lambda_url
  }
}