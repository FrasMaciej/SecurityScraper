resource "aws_lambda_function_url" "frontend_lambda_url" {
  function_name = var.frontend_lambda_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    max_age          = 86400
  }
} 