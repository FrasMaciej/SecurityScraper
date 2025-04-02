output "shodan_collector_lambda_name" {
  value = aws_lambda_function.fetch_from_shodan.function_name
}
