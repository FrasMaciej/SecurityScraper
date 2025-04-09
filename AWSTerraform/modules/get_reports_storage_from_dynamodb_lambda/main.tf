data "archive_file" "get_reports_storage_lambda_package" {
  type        = "zip"
  source_dir  = "../Api/get_reports_storage_from_dynamodb_lambda/"
  output_path = "../Api/get_reports_storage_from_dynamodb_lambda/get_reports_storage_lambda.zip"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "get_reports_storage_lambda" {
  function_name    = "get_reports_storage_lambda"
  runtime          = "python3.13"
  handler          = "get_reports_storage_from_dynamodb_lambda.lambda_handler"
  filename         = data.archive_file.get_reports_storage_lambda_package.output_path
  role             = aws_iam_role.lambda_role.arn
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
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.collector_reports_storage_table_name}"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "get_reports_storage_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_read_policy" {
  policy_arn = aws_iam_policy.dynamodb_read_access.arn
  role       = aws_iam_role.lambda_role.name
}

data "aws_apigatewayv2_api" "shodan_collector_api" {
  name = "shodan-collector-api"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = data.aws_apigatewayv2_api.shodan_collector_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_reports_storage_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "get_reports_route" {
  api_id    = data.aws_apigatewayv2_api.shodan_collector_api.id
  route_key = "GET /get-reports"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}