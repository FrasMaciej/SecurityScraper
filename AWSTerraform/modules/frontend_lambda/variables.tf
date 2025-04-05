variable "frontend_lambda_name" {
  description = "Name of the Lambda function for fetching data from shodan API"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function for fetching data from shodan API"
  type        = map(string)
  default     = {}
} 

variable "shodan_collector_lambda_url" {
  type = string
}