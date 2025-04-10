data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../FrontEnd/.output/server"
  output_path = "${path.module}/lambda_payload.zip"
}

resource "aws_lambda_function" "frontend_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.frontend_lambda_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  timeout         = 30
  memory_size     = 256
  publish         = true
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SECURITY_SCRAPER_API_GATEWAY_URL = var.security_scraper_api_gateway_url
    }
  } 
  
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.frontend_lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_public_access" {
  name = "${var.frontend_lambda_name}-public-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
          "lambda:InvokeAsync"
        ]
        Resource = aws_lambda_function.frontend_lambda.arn
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.frontend_lambda_name}"
  retention_in_days = 14
}

resource "aws_lambda_function_url" "frontend_lambda" {
  function_name      = aws_lambda_function.frontend_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    allow_origins     = ["*"]
    max_age          = 86400
  }
} 