variable "frontend_lambda_name" {
  description = "Name of the Lambda function for fetching data from shodan API"
  type        = string
}

variable "shodan_collector_lambda_url" {
  type = string
}