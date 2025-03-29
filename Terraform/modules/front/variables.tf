variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_payload_filename" {
  description = "Path to the Lambda function deployment package"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
} 