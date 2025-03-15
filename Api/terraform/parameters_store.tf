data "aws_ssm_parameter" "existing_shodan_api_key" {
  name = "/securityscraper/shodan/apikey"
}

resource "aws_ssm_parameter" "shodan_apikey" {  
  count = length(data.aws_ssm_parameter.existing_shodan_api_key.id) > 0 ? 0 : 1

  name  = "/securityscraper/shodan/apikey"
  type  = "SecureString"
  value = "value_to_change"

  tags = {
    Environment = "dev"
  }
}
