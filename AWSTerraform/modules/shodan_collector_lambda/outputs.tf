output "shodan_collector_lambda_name" {
  value = aws_lambda_function.shodan_collector_lambda.function_name
}

output "shodan_collector_lambda_url" {
  value = aws_lambda_function_url.shodan_collector_lambda_url.function_url
}