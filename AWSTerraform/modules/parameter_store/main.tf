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