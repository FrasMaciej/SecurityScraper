data "aws_ssm_parameter" "existing" {
  name = "/securityscraper/shodan/apikey"
}

resource "aws_ssm_parameter" "example" {
  count = length(data.aws_ssm_parameter.existing.id) > 0 ? 0 : 1
  
  name  = "/securityscraper/shodan/apikey"
  type  = "SecureString"
  value = "value_to_change"

  tags = {
    Environment = "dev"
  }
}
