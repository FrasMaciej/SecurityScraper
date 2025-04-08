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
}

module "frontend_lambda_link" {
  source               = "./modules/frontend_lambda_link"
  frontend_lambda_name = "security-scraper-frontend"
}

module "cognito_user_pool_for_frontend" {
  source                = "./modules/cognito_user_pool_for_frontend"
  pool_name             = "frontend_user_pool"
  cognito_domain_prefix = "frontend-user-pool-domain"
  callback_url          = module.frontend_lambda_link.frontend_lambda_url
  logout_url            = module.frontend_lambda_link.frontend_lambda_url
  aws_region            = "us-east-1"
}

module "frontend_lambda" {
  source                           = "./modules/frontend_lambda"
  security_scraper_api_gateway_url = module.shodan_collector_lambda.security_scraper_api_gateway_url
  cognito_authority                = module.cognito_user_pool_for_frontend.cognito_authority
  cognito_client_id                = module.cognito_user_pool_for_frontend.client_id
  cognito_redirect_uri             = module.frontend_lambda_link.frontend_lambda_url
  frontend_lambda_url              = module.frontend_lambda_link.frontend_lambda_url
}


