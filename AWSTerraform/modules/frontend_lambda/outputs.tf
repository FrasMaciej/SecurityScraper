output "security_scraper_frontend_lambda_url" {
  description = "The URL of the Lambda that returns frontend to interact with API"
  value       = aws_lambda_function_url.frontend_lambda.function_url
}

output "security_scraper_frontend_lambda_name" {
  description = "The name of the Lambda function that returns frontend to interact with API"
  value       = aws_lambda_function.frontend_lambda.function_name
}

output "security_scraper_frontend_lambda_arn" {
  description = "The ARN of the Lambda function that returns frontend to interact with API"
  value       = aws_lambda_function.frontend_lambda.arn
} 