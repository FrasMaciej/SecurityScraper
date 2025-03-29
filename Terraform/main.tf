module "ssm" {
  source = "./modules/ssm"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "lambda" {
  source      = "./modules/lambda"
  bucket_name = var.bucket_name
}

module "frontend" {
  source = "./modules/front"

  function_name           = "security-scraper-frontend"
  lambda_payload_filename = "../FrontEnd/payload.zip"
}
