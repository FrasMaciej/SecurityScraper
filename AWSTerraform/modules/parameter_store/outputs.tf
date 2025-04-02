output "shodan_apikey_parameter" {
  value = aws_ssm_parameter.shodan_apikey.name
}
