output "shodan_collector_lambda_url" {
  description = "The URL of the Lambda that returns frontend to interact with API"
  value       = aws_lambda_function_url.frontend.function_url
}

output "shodan_collector_lambda_name" {
  description = "The name of the Lambda function that returns frontend to interact with API"
  value       = aws_lambda_function.frontend.function_name
}

output "shodan_collector_lambda_arn" {
  description = "The ARN of the Lambda function that returns frontend to interact with API"
  value       = aws_lambda_function.frontend.arn
} 