output "shodan_collector_lambda_name" {
  value = aws_lambda_function.shodan_collector_lambda.function_name
}

output "security_scraper_api_gateway_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "shodan_collector_api_id" {
  value = aws_apigatewayv2_api.shodan_collector_api.id
}