data "aws_caller_identity" "current" {}

module "parameter_store" {
  source = "./modules/parameter_store"
}

module "collector_reports_storage_dynamodb" {
  source                               = "./modules/collector_reports_storage_dynamodb"
  collector_reports_storage_table_name = var.collector_reports_storage_table_name
  aws_region                           = var.region
  aws_account_id                       = data.aws_caller_identity.current.account_id
}

module "shodan_collector_lambda" {
  source                               = "./modules/shodan_collector_lambda"
  collector_reports_storage_table_name = var.collector_reports_storage_table_name
  aws_region                           = var.region
}

module "get_reports_storage_from_dynamodb_lambda" {
  source                               = "./modules/get_reports_storage_from_dynamodb_lambda"
  collector_reports_storage_table_name = var.collector_reports_storage_table_name
  aws_region                           = var.region
  shodan_collector_api_id              = module.shodan_collector_lambda.shodan_collector_api_id
  shodan_collector_api_execution_arn   = module.shodan_collector_lambda.shodan_collector_api_execution_arn
}

module "frontend_lambda" {
  source                           = "./modules/frontend_lambda"
  frontend_lambda_name             = "security-scraper-frontend"
  security_scraper_api_gateway_url = module.shodan_collector_lambda.security_scraper_api_gateway_url
}