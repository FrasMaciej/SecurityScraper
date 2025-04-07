module "parameter_store" {
  source = "./modules/parameter_store"
}

module "collector_reports_storage_s3" {
  source                                = "./modules/collector_reports_storage_s3"
  collector_reports_storage_bucket_name = var.collector_reports_storage_bucket_name
}

module "shodan_collector_lambda" {
  source                                = "./modules/shodan_collector_lambda"
  collector_reports_storage_bucket_name = var.collector_reports_storage_bucket_name
}

module "frontend_lambda" {
  source                           = "./modules/frontend_lambda"
  frontend_lambda_name             = "security-scraper-frontend"
  security_scraper_api_gateway_url = module.shodan_collector_lambda.security_scraper_api_gateway_url
}

module "cognito_user_pool_for_frontend" {
  source                = "./modules/cognito_user_pool_for_frontend"
  pool_name             = "frontend_user_pool"
  cognito_domain_prefix = "frontend-user-pool-domain"
  callback_url          = "https://lt4fop4ihlbrptsqxumwqz7w5u0wtxee.lambda-url.eu-central-1.on.aws/"
  logout_url            = "https://lt4fop4ihlbrptsqxumwqz7w5u0wtxee.lambda-url.eu-central-1.on.aws/logout"
  aws_region            = "us-east-1"
}

output "frontend_client_id" {
  value = module.cognito_user_pool_for_frontend.client_id
}