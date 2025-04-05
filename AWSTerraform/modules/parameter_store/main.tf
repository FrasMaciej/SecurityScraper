resource "aws_ssm_parameter" "shodan_apikey" {
  name  = "/securityscraper/shodan/apikey"
  type  = "SecureString"
  value = "value_to_set"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "shodan_collector_lambda_url" {
  name  = "/securityscraper/shodan/lambda_url"
  type  = "String"
  value = var.shodan_collector_lambda_url

  tags = {
    Environment = "dev"
  }
}