output "shodan_collector_lambda_name" {
  value = aws_lambda_function.shodan_collector_lambda.function_name
}

output "security_scraper_api_gateway_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}