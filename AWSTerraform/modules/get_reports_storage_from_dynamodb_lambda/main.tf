data "archive_file" "get_reports_storage_lambda_package" {
  type        = "zip"
  source_dir  = "../Api/get_reports_storage_from_dynamodb_lambda/"
  output_path = "../Api/get_reports_storage_from_dynamodb_lambda/get_reports_storage_lambda.zip"
}

resource "aws_lambda_function" "get_reports_storage_lambda" {
  function_name    = "get_reports_storage_lambda"
  runtime          = "python3.13"
  handler          = "get_reports_storage_from_dynamodb_lambda.lambda_handler"
  filename         = data.archive_file.get_reports_storage_lambda_package.output_path
  role             = var.lambda_role_arn
  source_code_hash = data.archive_file.get_reports_storage_lambda_package.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.collector_reports_storage_table_name
    }
  }
}

resource "aws_iam_policy" "dynamodb_read_access" {
  name        = "DynamoDBReadAccessPolicy"
  description = "Allows Lambda to read data from the DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem"
        ],
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.collector_reports_storage_table_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_read_policy" {
  policy_arn = aws_iam_policy.dynamodb_read_access.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_apigatewayv2_api" "get_reports_storage_api" {
  name          = "get-reports-storage-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.get_reports_storage_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_reports_storage_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.get_reports_storage_api.id
  route_key = "GET /get-reports"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.get_reports_storage_api.id
  name        = "prod"
  auto_deploy = true
}