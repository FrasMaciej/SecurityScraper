module "parameter_store" {
  source = "./modules/parameter_store"
}

module "collector_reports_storage_s3" {
  source      = "./modules/collector_reports_storage_s3"
  collector_reports_storage_bucket_name = var.collector_reports_storage_bucket_name
}

module "shodan_collector_lambda" {
  source      = "./modules/shodan_collector_lambda"
  collector_reports_storage_bucket_name = var.collector_reports_storage_bucket_name
}

module "frontend_lambda" {
  source        = "./modules/frontend_lambda"
  frontend_lambda_name = "security-scraper-frontend"
}
