output "function_url" {
  description = "The URL of the Lambda function"
  value       = aws_lambda_function_url.frontend.function_url
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.frontend.function_name
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.frontend.arn
} 